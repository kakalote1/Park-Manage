//
//  AppDelegate.h
//  ImoocHybridIOSNative
//
//  Created by LGD_Sunday .
//  Copyright © LGD_Sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ScPoc/SipContext.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SipContext *sipContext;

-(void)serverRequestWithUrl;


@end

