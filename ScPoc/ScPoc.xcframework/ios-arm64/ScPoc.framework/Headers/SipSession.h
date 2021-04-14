//
// Created by Williem.T.L on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import "SipInviteEvent.h"

@class SipCall;


@interface SipSession : NSObject

- (instancetype)initWithCall:(SipCall *)call;

- (void)destroy;

- (void)acceptCall;

- (void)hangupCall:(NSString *)reason;

- (void)sendDTMF:(NSString *)digits;

- (void)sendInfo:(NSString *)content contentType:(NSString *)contentType;

- (float)getMicrophoneLevel;

- (void)adjustMicrophoneLevel:(float)level;

- (float)getVolumeLevel;

- (void)adjustVolumeLevel:(float)level;

- (int)getId;

- (NSString *)getRemotePartyDisplayName;

- (BOOL)isVideoCall;

- (BOOL)isOutgoing;

- (NSString *)getCallIDString;

- (SipInviteEventType)getState;

- (BOOL)isTerminated;

- (BOOL)isMeeting;

@end
