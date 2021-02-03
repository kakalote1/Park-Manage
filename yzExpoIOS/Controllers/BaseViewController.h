//
//  BaseViewController.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/1.
//  Copyright © 2021 LGD_Sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ScPoc/SipContext.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

- (SipContext *)getSipContext;

@end

NS_ASSUME_NONNULL_END
