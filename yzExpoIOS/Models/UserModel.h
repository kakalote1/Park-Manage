//
//  UserModel.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/3/22.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *sid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *real_name;
@property(nonatomic,strong)NSString *begin_time;
@property(nonatomic,strong)NSString *end_time;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *status_info;
@property(nonatomic,strong)NSString *expires_in;
@property(nonatomic,strong)NSString *accessToken;
@property(nonatomic,strong)NSString *open_id;
@property(nonatomic,strong)NSString *data;
@property(nonatomic,strong)NSString *face_id;
@property(nonatomic,strong)NSString *longitude;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *devToken;


-(id)initWithDic:(NSDictionary *)dic;

-(id)initWithDicWithoutSave:(NSDictionary *)dic;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
