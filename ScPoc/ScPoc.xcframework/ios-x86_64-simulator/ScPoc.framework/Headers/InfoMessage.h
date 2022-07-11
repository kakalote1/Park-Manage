//
// Created by Williem.T.L on 2021/3/23.
//

#import <Foundation/Foundation.h>

#define INFO_MSG_CONTENT_CHARSET @"UTF-8"
#define INFO_MSG_CONTENT_TYPE @"application/xml"

#define INFO_MSG_FIELD_OP           @"op"
#define INFO_MSG_FIELD_TYPE         @"type"
#define INFO_MSG_FIELD_RESULT       @"result"
#define INFO_MSG_FIELD_STATE        @"state"
//meeting

#define INFO_MSG_OP_REQUEST @"request"
#define INFO_MSG_OP_RESPONSE @"response"
#define INFO_MSG_OP_NOTIFY @"notify"

#define INFO_MSG_TYPE_GROUP @"group"
#define INFO_MSG_TYPE_GROUP_STATE @"group_state"
#define INFO_MSG_TYPE_MEMBER_STATE @"member_state"

typedef NS_ENUM(NSInteger, SipInfoMessageOp) {
    SipInfoMsgOpRequest,
    SipInfoMsgOpResponse,
    SipInfoMsgOpNotify
};

@interface InfoMessage : NSObject

@property (strong, nonatomic, readonly) NSDictionary *info;

@property (nonatomic, readonly) SipInfoMessageOp op;

- (instancetype)initWithInfo:(NSDictionary *)info;

- (BOOL)has:(NSString *)key;
- (NSInteger)optInt:(NSString *)key;
- (long long)optLong:(NSString *)key;
- (double)optDouble:(NSString *)key;
- (BOOL)optBool:(NSString *)key;
- (NSString *)optString:(NSString *)key;
- (NSObject *)optObject:(NSString *)key;
- (NSArray *)optArray:(NSString *)key;

+ (SipInfoMessageOp)formatOp:(NSString *)type;

+ (NSString *)opStringValue:(SipInfoMessageOp)type;

@end