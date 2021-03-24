//
//  HttpManager.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/22.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+(instancetype)shareInstance{
    static HttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}


-(void)postRequestWithUrl:(NSString *)url andParam:(NSDictionary *)param andHeaders:(NSString *)header andSuccess:(void (^)(id))success andFail:(void (^)(id))fail{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"PLATE_NUMBER_LIST" forHTTPHeaderField:@"cookie"];
    [manager.requestSerializer setTimeoutInterval:6];
    
    NSLog(@"URL:%@\n param:%@\n\n",url,param);
    
    [manager POST:url parameters:param headers:header progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        success(dic);
        NSLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        NSLog(@"请求失败%@",error);
        //
    }];
}

@end
