//
//  CallUtil.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/3.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import <ScPoc/SipContext.h>
#import <ScPoc/SipSession.h>
#import <ScPoc/IphoneControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallUtil : BaseViewController

- (void)makeAudioCall:(NSString *)sender;

- (void)makeVideoCall:(NSString *)sender;

- (void)makeAudioGroupCall:(NSString *)sender;

- (void)makeVideoGroupCall:(NSString *)sender;

@end

NS_ASSUME_NONNULL_END
