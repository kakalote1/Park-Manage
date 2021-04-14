//
//  UserModel.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/22.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize uid;

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
        self = [self init];
        self.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        self.sid = dic[@"sid"];
        self.username = dic[@"username"];
        self.email = dic[@"email"];
        self.real_name = dic[@"real_name"];
        self.face_id = dic[@"face_id"];
        NSLog(@"userDefault: %@",self.uid);
        [[NSUserDefaults standardUserDefaults]setValue:self.uid forKey:@"uid"];
    }
    return self;
}

-(id)initWithDicWithoutSave:(NSDictionary *)dic{
    if (self) {
        self = [self init];
        self.uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
        self.sid = dic[@"sid"];
        self.username = dic[@"username"];
        self.email = dic[@"email"];
        self.real_name = dic[@"real_name"];
        self.face_id = dic[@"face_id"];
        NSLog(@"userDefault: %@",self.uid);
        
    }
    return self;
}

@end
