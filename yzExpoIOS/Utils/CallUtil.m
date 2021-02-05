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
}

- (void)makeVideoGroupCall:(NSString *)sender {
    NSLog(@"拨打群组视频");
}
@end
