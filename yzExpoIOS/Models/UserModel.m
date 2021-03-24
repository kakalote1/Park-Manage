//
//  UserModel.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/22.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

static UserModel *model = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc]init];
    });
    return model;
}

-(id)initWithDic:(NSDictionary *)dic{
    if (self) {
        self = [super init];
        self.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        self.sid = dic[@"sid"];
        self.username = dic[@"username"];
        self.email = dic[@"email"];
        self.real_name = dic[@"real_name"];
        [[NSUserDefaults standardUserDefaults]setValue:_uid forKey:@"uid"];
    }
    return self;
}

@end
