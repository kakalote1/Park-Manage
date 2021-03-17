//
// Created by Williem.T.L on 2021/2/23.
//

#import <Foundation/Foundation.h>

@class SipContext;
@import UIKit;


@interface VideoManager : NSObject

- (instancetype)initWithSipContext:(SipContext *)sipContext;

- (void)initWithRemote:(UIView *)remoteContainerView local:(UIView *)localContainerView;

- (void)initWithRemote:(UIView *)remoteContainerView;

- (void)changeContainerView:(UIView *)toCameraView decode:(UIView *)toDecodeView send:(BOOL)isSendVideo;

- (void)toggleCamera;

- (void)destroy;

- (void)destroyPart;

- (void)startSocket;

- (void)sendPreview:(BOOL)send;

- (BOOL)isSendPreview;

- (void)destroySocket;

@end
