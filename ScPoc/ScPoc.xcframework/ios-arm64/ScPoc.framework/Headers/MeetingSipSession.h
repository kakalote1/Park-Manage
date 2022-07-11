//
// Created by Williem.T.L on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import "SipSession.h"
#import "SipMeetingMessage.h"


@interface MeetingSipSession : SipSession

@property (nonatomic) BOOL isHost;

- (NSArray<NSString *> *)getMeetingMembers;

- (void)addMeetingMember:(NSString *)member;

- (void)removeMeetingMember:(NSString *)member;

- (void)sendMeetingConReq:(SipMeetingMessageType)type;

- (void)sendMeetingConReq:(SipMeetingMessageType)type tel:(NSString *)tel;

@end
