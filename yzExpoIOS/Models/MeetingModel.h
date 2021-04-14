//
//  MeetingModel.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/10.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingModel : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *tel;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) NSDictionary *dic;

@property (strong, nonatomic) NSArray *dataList;

-(id)initWithDic:(NSDictionary *)dic;

-(id)initWithArray:(NSArray *)array;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
