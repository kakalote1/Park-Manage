//
//  CallUtil.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/3.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "CallUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <ScPoc/SipContext.h>
#import <ScPoc/SipSession.h>
#import <ScPoc/IphoneControl.h>
#import <ScPoc/MeetingManager.h>
#import "MeetingModel.h"

@implementation CallUtil

- (void)makeAudioCall:(NSString *)sender {
    NSLog(@"拨打语音通话");
    NSLog(@"%@",sender);
    [self.getSipContext makeCall:sender isVideoCall:NO];
}

- (void)makeVideoCall:(NSString *)sender {
    NSLog(@"拨打视频通话");
    [self.getSipContext makeCall:sender isVideoCall:YES];
}

- (void)makeAudioGroupCall:(NSString *)sender {
    NSLog(@"拨打群组语音");
    NSLog(@"sender: %@", sender);
    NSData *data = [sender dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"listcount: %lu",(unsigned long)array.count);
    NSMutableArray *telList = [NSMutableArray new];
    for (NSDictionary *dic in array) {
   
        [telList addObject:dic[@"tel"]];
               NSLog(@"sender list: %@",dic);
    }
    NSLog(@"meetingdic ： %@", telList);
    MeetingModel *meetingModel = [MeetingModel shareInstance];
    [meetingModel initWithDic:telList];
    [meetingModel initWithArray:array];
    [[[self getSipContext] getMeetingManager] createMeeting:NO];
}

- (void)makeVideoGroupCall:(NSString *)sender {
    NSLog(@"拨打群组视频");
    NSData *data = [sender dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"listcount: %lu",(unsigned long)array.count);
    NSMutableArray *telList = [NSMutableArray new];
    for (NSDictionary *dic in array) {
   
        [telList addObject:dic[@"tel"]];
               NSLog(@"sender list: %@",dic);
    }
    NSLog(@"meetingdic ： %@", telList);
    MeetingModel *meetingModel = [MeetingModel shareInstance];
    [meetingModel initWithDic:telList];
    [meetingModel initWithArray:array];
    [[[self getSipContext] getMeetingManager] createMeeting:YES];
}
@end
