//
//  AudioCallViewController.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/1.
//  Copyright © 2021 LGD_Sunday. All rights reserved.
//

#import "BaseViewController.h"
#import <ScPoc/SipSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioCallViewController : BaseViewController

- (void)setAvSession:(SipSession *)avSession;

@end

NS_ASSUME_NONNULL_END
