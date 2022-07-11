//
// Created by Williem.T.L on 2021/3/22.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SipUtils)

- (NSString *)toJson;

+ (NSDictionary *)jsonToNSDictionary:(NSString *)json;

@end