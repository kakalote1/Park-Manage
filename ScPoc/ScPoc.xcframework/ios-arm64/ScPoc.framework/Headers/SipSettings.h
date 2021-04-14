//
// Created by Williem.T.L on 2021/2/23.
//

#import <Foundation/Foundation.h>

@class SipConfigurationService;


@interface SipSettings : NSObject

- (SipConfigurationService *)configService;

#pragma mark - video

- (int)getQosPrefVideoSize;

- (void)setQosPrefVideoSize:(int)sizeTag;

- (BOOL)getVideoUseBackCamera;

- (void)setVideoUseBackCamera:(BOOL)back;

- (int)getVideoEncoderFps;

- (void)setVideoEncoderFps:(int)fps;

- (int)getVideoEncoderBitrate;

- (void)setVideoEncoderBitrate:(int)bitrate;

- (BOOL)getVideoTransUseUdp;

- (void)setVideoTransUseUdp:(BOOL)udp;

- (BOOL)meetingMedia;

- (void)setMeetingMedia:(BOOL)meetingMedia;

- (NSString *)dispatchNum;

- (void)setDispatchNum:(NSString *)dispatchNum;

@end