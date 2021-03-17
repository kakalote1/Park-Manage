//
// Created by Williem.T.L on 2021/1/20.
//

#import <Foundation/Foundation.h>

#define NOTIFY_NAME_INVITE_EVENT @"notification_name_sip_invite_event"

typedef NS_ENUM(NSInteger, SipInviteEventType) {
    INCOMING,
    INPROGRESS,
    EARLY_MEDIA,
    CONNECTING,
    CONNECTED,
    TERMINATED

};

@interface SipInviteEvent : NSObject

- (instancetype)init:(int)sessionId eventType:(SipInviteEventType)type ringing:(BOOL)ringing;

- (int)sessionId;

- (SipInviteEventType)eventType;

- (BOOL)ringing;

@end