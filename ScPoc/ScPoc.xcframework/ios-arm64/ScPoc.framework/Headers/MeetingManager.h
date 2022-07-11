//
// Created by Williem.T.L on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import "SipMeetingMessage.h"

@class SipContext;
@class SipSession;

@interface MeetingMemberState : NSObject

@property (strong, nonatomic) NSString *tel;

@property (nonatomic) BOOL isVideo;

@property (nonatomic) NSUInteger volumeLvl;

@property (nonatomic) SipMeetingMessageState state;

- (instancetype)initWithTel:(NSString *)tel;


@end

@protocol MeetingEventDelegate <NSObject>

@required
- (void)handleConnected:(SipSession *)sipSession;

- (void)handleTerminated;

- (void)handleJoin:(NSArray<NSString *> *)joinArray;

- (void)handleLeave:(NSArray<NSString *> *)leaveArray;

- (void)handleSource:(NSString *)source;

- (void)handleAllAudience:(BOOL)isAllAudience members:(NSArray<NSString *> *)members;

- (void)handleLookVideoWithOld:(NSString *)oldLookTel current:(NSString *)currentLookTel;

- (void)handleMemberStateChange:(NSString *)memberTel isVideo:(BOOL)video volume:(NSUInteger)volLevel
                          state:(SipMeetingMessageState)state;

@optional
- (void)handleAllLocked:(BOOL)isAllLocked;

@end

@interface MeetingManager : NSObject

@property (nonatomic) BOOL isInMeeting;

- (instancetype)initWithSipContext:(SipContext *)sipContext;

- (void)destroy;

- (void)registerReceiver:(id<MeetingEventDelegate>)listener;

- (void)unregisterReceiver:(id<MeetingEventDelegate>)listener;

- (BOOL)isAllAudience;

- (BOOL)isAllLocked;

- (BOOL)isAllFollow;

- (BOOL)isAlong;

#pragma mark - control method

- (BOOL)createMeeting:(BOOL)video;

- (void)hangupMeeting;

- (void)meetingEnd:(int)callId;

- (BOOL)addMeetingMember:(NSString *)tel;

- (BOOL)sendAllAudience;

- (BOOL)sendAudience:(NSString *)tel audience:(BOOL)audienceState;

- (BOOL)sendFollow:(NSString *)tel follow:(BOOL)followState;

- (BOOL)sendLookVideo:(NSString *)tel lookVideo:(BOOL)lookVideoState;

- (BOOL)reCall:(NSString *)tel state:(SipMeetingMessageState)state;

- (BOOL)hangup:(NSString *)tel state:(SipMeetingMessageState)state;

- (BOOL)alongCall:(NSString *)tel along:(BOOL)alongState;

@end
