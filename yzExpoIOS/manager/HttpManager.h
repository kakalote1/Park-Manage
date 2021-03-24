//
//  HttpManager.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/22.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface HttpManager : NSObject
+(instancetype)shareInstance;

-(void)postRequestWithUrl:(NSString *)url andParam:(NSDictionary *)param andHeaders:(NSString *)header andSuccess:(void(^)(id responseObject))success andFail:(void(^)(id error))fail;


@end
