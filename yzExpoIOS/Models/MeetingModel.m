//
//  MeetingModel.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/10.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "MeetingModel.h"

@implementation MeetingModel

static MeetingModel *model = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc]init];
    });
    return model;
}

-(id)initWithDic:(NSArray *)list{
    if (self) {
        self = [self init];
        self.list = list;
        
        NSLog(@"meetingmodeldic: %@", self.list);
    }
    return self;
}

-(id)initWithArray:(NSArray *)array {
    if (self) {
        self = [self init];
        self.dataList = array;
    }
    return self;
}

@end
