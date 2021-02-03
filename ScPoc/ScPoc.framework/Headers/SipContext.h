//
//  SipContext.h
//  ScPoc
//
//  Created by Williem.T.L on 2021/1/13.
//

#import <Foundation/Foundation.h>

@class SipSession;
@class SipApp;

NS_ASSUME_NONNULL_BEGIN

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

- (void)shutdown;

- (void)libRegisterThread:(NSString *)name;

- (BOOL)isLibRegister;

- (void)loginToSip:(NSString *)user
              pass:(NSString *)pass
              host:(NSString *)host
              port:(int16_t)port
               tls:(BOOL)tls;

- (void)logoutSip;

- (void)reRegister;

- (void)makeCall:(NSString *)tel isVideoCall:(BOOL)videoCall;

- (SipSession *)getCurrentSession;

- (void)setCurrentSession:(SipSession *)currentSession;

- (void)removeCurrentSession;

- (BOOL)isStarted;

/**
 * 设置当前注册状态
 */
- (void)setRegState:(BOOL)success;

/**
 * 已成功注册过
 */
- (BOOL)hasSuccessRegister;

- (SipApp *)sipApp;

@end

NS_ASSUME_NONNULL_END
