//
// Created by Williem.T.L on 2021/1/20.
//

#import <Foundation/Foundation.h>

@class SipCall;


@interface SipSession : NSObject

- (instancetype)initWithCall:(SipCall *)call;

- (void)destroy;

- (int)makeCall;

- (void)acceptCall;

- (void)hangupCall:(NSString *)reason;

- (int)getId;

- (NSString *)getRemotePartyDisplayName;

- (BOOL)isVideoCall;

- (BOOL)isOutgoing;

- (NSString *)getCallIDString;

- (BOOL)isTerminated;


@end