//
// Created by Williem.T.L on 2021/1/26.
//

#import <Foundation/Foundation.h>

@interface IphoneControl : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)shareInstance;

- (void)startRing;

- (void)stopRing;

- (void)startVibration;

- (void)stopVibration;

@end
