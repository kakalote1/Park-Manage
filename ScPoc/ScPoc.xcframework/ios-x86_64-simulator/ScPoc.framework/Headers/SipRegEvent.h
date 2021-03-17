//
// Created by Williem.T.L on 2021/1/20.
//

#import <Foundation/Foundation.h>

#define NOTIFY_NAME_REGISTRATION_EVENT @"notification_name_sip_registration_event"

@interface SipRegEvent : NSObject

// 登录结果
@property (nonatomic) int32_t code;

// 失败原因
@property (strong, nonatomic) NSString *reason;

// 协商保活超时事件
@property (nonatomic) int expiration;

// 切换登录账号CallID
@property (nonatomic) BOOL changeCallId;

- (instancetype)initWithCode:(int32_t) code
                      reason:(NSString *)reason
                  expiration:(int)expiration
                changeCallId:(BOOL)changeCallId;

@end
