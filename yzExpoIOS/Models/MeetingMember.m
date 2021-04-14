//
// Created by Williem.T.L on 2021/3/26.
//

#import "MeetingMember.h"


@implementation MeetingMember

- (instancetype)initWithTel:(NSString *)tel video:(BOOL)video name:(NSString *)name {
    self = [super init];
    if (self) {
        _tel = tel;
        _name = name;
        self.video = video;
        self.state = SipMeetingMsgStateMeetTalk;
    }

    return self;
}

- (void)setState:(SipMeetingMessageState)state {
    _state = state;
    if (_state == SipMeetingMsgStateAudience) {
        _audience = YES;
    } else if (_state == SipMeetingMsgStateSpeaking) {
        _audience = NO;
    } else if (_state == SipMeetingMsgStatePrivateTalk) {
        _along = YES;
        _audience = NO;
    } else if (_state == SipMeetingMsgStateMeetTalk) {
        _along = NO;
        _audience = NO;
    } else if (_state == SipMeetingMsgStateSendVideo) {
        _follow = YES;
        _lookVideo = NO;
    } else if (_state == SipMeetingMsgStateLookVideo) {
        _lookVideo = YES;
    } else if (_state != nil) {
        _audience = NO;
        _along = NO;
        _follow = NO;
        _lookVideo = NO;
    }
}

- (void)cancelFollow {
    _follow = NO;
}

- (void)cancelLookVideo {
    _lookVideo = NO;
}

@end
