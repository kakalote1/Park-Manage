//
// Created by Williem.T.L on 2021/3/26.
//

#import <Foundation/Foundation.h>
#import <ScPoc/SipMeetingMessage.h>


@interface MeetingMember : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *tel;
@property (nonatomic) BOOL video;
@property (nonatomic) SipMeetingMessageState state;
@property (nonatomic, readonly) BOOL audience;
@property (nonatomic, readonly) BOOL along;
@property (nonatomic, readonly) BOOL follow;
@property (nonatomic, readonly) BOOL lookVideo;

- (instancetype)initWithTel:(NSString *)tel video:(BOOL)video name:(NSString *)name;

- (void)cancelFollow;

- (void)cancelLookVideo;

@end
