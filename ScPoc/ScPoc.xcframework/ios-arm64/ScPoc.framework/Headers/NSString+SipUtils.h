//
// Created by Williem.T.L on 2021/2/23.
//

#import <Foundation/Foundation.h>

@interface NSString (SipUtils)

- (BOOL)startWith:(NSString *)dst;

+ (BOOL)isEmpty:(NSString *)src;

+ (BOOL)isEmptyOrWhitespace:(NSString *)src;

@end