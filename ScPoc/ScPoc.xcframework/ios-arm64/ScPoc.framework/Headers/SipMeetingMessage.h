//
// Created by Williem.T.L on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import "InfoMessage.h"

#define FIELD_MEETING_JOIN          @"join"
#define FIELD_MEETING_LEAVE         @"leave"
#define FIELD_MEETING_V_SOURCE      @"v_src"
#define FIELD_MEETING_LOCKED        @"locked"
#define FIELD_MEETING_FOLLOW        @"av_follow"
#define FIELD_MEETING_ALL_AUDIENCE  @"all_audience"
#define FIELD_MEETING_HOST          @"chairman"
#define FIELD_MEETING_MEMBER_LIST   @"members"
#define FIELD_MEETING_MEMBER        @"member"
#define FIELD_MEETING_TEL           @"tel"
#define FIELD_MEETING_VOLUME_LEVEL  @"vol_level"
#define FIELD_MEETING_MEMBER_TYPE   @"member_type"
#define FIELD_MEETING_STATE         @"state"
#define FIELD_MEETING_CALLER        @"handleTel"
#define FIELD_MEETING_CALLED        @"conTel"
#define FIELD_MEETING_CENTER_ID     @"centerId"

#define INFO_MSG_FIELD_SCOPE @"scope"
#define INFO_MSG_FIELD_TEL @"tel"

#define INFO_MSG_SCOPE_MEETING @"meeting"

#define STATE_MEETING_LOOK_VIDEO    @"look_video"

typedef NS_ENUM(NSInteger, SipMeetingMessageType) {
    SipMeetingMsgTypeJoinMeet = 1,
    SipMeetingMsgTypeLeaveMeet,
    SipMeetingMsgTypeVSrc,
    SipMeetingMsgTypeAudience,
    SipMeetingMsgTypeSpeak,
    SipMeetingMsgTypeLock,
    SipMeetingMsgTypeUnlock,
    SipMeetingMsgTypeAllAudience,
    SipMeetingMsgTypeAllSpeak,
    SipMeetingMsgTypeAvFollow,
    SipMeetingMsgTypeNoFollow,
    SipMeetingMsgTypeMeetingState,
    SipMeetingMsgTypeMemberState,
    SipMeetingMsgTypeLookVideo,
    SipMeetingMsgTypeCancelVideo,
    SipMeetingMsgTypePrivateTalk,
    SipMeetingMsgTypeMeetTalk,
    SipMeetingMsgTypeCall2Meet
};

typedef NS_ENUM(NSInteger, SipMeetingMessageState) {
    SipMeetingMsgStateCallstRing = 1,
    SipMeetingMsgStateCallstFail,
    SipMeetingMsgStateAudience,
    SipMeetingMsgStateSpeaking,
    SipMeetingMsgStateWaiting,
    SipMeetingMsgStateLeave,
    SipMeetingMsgStatePrivateTalk,
    SipMeetingMsgStateMeetTalk,
    SipMeetingMsgStateSendVideo,
    SipMeetingMsgStateLookVideo
};

@interface SipMeetingMessage : InfoMessage

@property (nonatomic, readonly) SipMeetingMessageType type;

- (NSString *)scope;

- (BOOL)isMeetingScope;

+ (SipMeetingMessageType)formatType:(NSString *)type;

+ (NSString *)typeStringValue:(SipMeetingMessageType)type;

+ (SipMeetingMessageState)formatState:(NSString *)state;

+ (NSString *)stateStringValue:(SipMeetingMessageState)state;

@end