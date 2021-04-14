//
//  SipContext.h
//  ScPoc
//
//  Created by Williem.T.L on 2021/1/13.
//

#import <Foundation/Foundation.h>

@class SipSession;
@class SipApp;
@class SipSettings;
@class SipConfigurationService;
@class VideoManager;
@class VideoManager;
@class MeetingManager;

NS_ASSUME_NONNULL_BEGIN

#define DEFAULT_BIND_PORT 5060

@interface SipContext : NSObject

/**
 * 向服务器注册中
 */
@property (nonatomic) BOOL inRegistering;

/**
 * 获取单例
 */
+ (instancetype)sharedInstance;

- (void)startup;

- (void)startup:(unsigned int)bindPort;

- (void)shutdown;

- (SipSettings *)settings;

- (SipConfigurationService *)getConfigurationService;

+ (void)libRegisterThread:(NSString *)name;

+ (BOOL)isLibRegister;

- (void)loginWithUid:(NSString *)uid
                host:(NSString *)host
                port:(uint16_t)port
                 tls:(BOOL)tls;

- (void)loginToSip:(NSString *)user
              pass:(NSString *)pass
              host:(NSString *)host
              port:(uint16_t)port
               tls:(BOOL)tls;

- (void)logoutSip;

- (void)reRegister;

- (void)makeCall:(NSString *)tel isVideoCall:(BOOL)videoCall;

- (void)makeMeeting:(NSString *)tel isVideoCall:(BOOL)videoCall;

- (SipSession *)getCurrentSession;

- (void)setCurrentSession:(SipSession *)currentSession;

- (void)removeCurrentSession;

- (VideoManager *)getVideoManager;

- (MeetingManager *)getMeetingManager;

- (void)meetingStop;

- (NSString *)getLoginUser;

- (NSString *)getLoginServer;

- (BOOL)isStarted;

/**
 * 设置当前注册状态
 */
- (void)setRegState:(BOOL)success;

/**
 * 已成功注册过
 */
- (BOOL)hasSuccessRegister;

- (BOOL)isSpeakerphoneOn;

- (void)setSpeakerphoneOn:(BOOL)speakerphoneOn;

- (SipApp *)sipApp;

@end

NS_ASSUME_NONNULL_END
