//
// Created by Williem.T.L on 2021/2/23.
//

#import <Foundation/Foundation.h>

@interface SipConfigurationService : NSObject

- (void)putInteger:(NSInteger)value forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;
- (void)putFloat:(float)value forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;
- (void)putDouble:(double)value forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;
- (void)putBool:(BOOL)value forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;
- (void)putURL:(nullable NSURL *)url forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;
- (void)putString:(nullable NSString *)value forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;
- (void)putArray:(nullable NSArray *)value forKey:(nonnull NSString *)defaultName withCommit:(BOOL)commit;


- (void)putInteger:(NSInteger)value forKey:(nonnull NSString *)defaultName;
- (void)putFloat:(float)value forKey:(nonnull NSString *)defaultName;
- (void)putDouble:(double)value forKey:(nonnull NSString *)defaultName;
- (void)putBool:(BOOL)value forKey:(nonnull NSString *)defaultName;
- (void)putURL:(nullable NSURL *)url forKey:(nonnull NSString *)defaultName;
- (void)putString:(nullable NSString *)value forKey:(nonnull NSString *)defaultName;
- (void)putArray:(nullable NSArray *)value forKey:(nonnull NSString *)defaultName;

- (NSInteger)integerForKey:(NSString *)defaultName withDefault:(NSInteger)defaultValue;
- (NSInteger)integerForKey:(nonnull NSString *)defaultName;
- (float)floatForKey:(NSString *)defaultName withDefault:(float)defaultValue;
- (float)floatForKey:(nonnull NSString *)defaultName;
- (double)doubleForKey:(NSString *)defaultName withDefault:(double)defaultValue;
- (double)doubleForKey:(nonnull NSString *)defaultName;
- (BOOL)boolForKey:(NSString *)defaultName withDefault:(BOOL)defaultValue;
- (BOOL)boolForKey:(nonnull NSString *)defaultName;
- (nullable NSURL *)URLForKey:(nonnull NSString *)defaultName;
- (nullable NSString *)stringForKey:(nonnull NSString *)defaultName withDefault:(NSString *)defaultValue;
- (nullable NSString *)stringForKey:(nonnull NSString *)defaultName;
- (nullable NSArray *)arrayForKey:(nonnull NSString *)defaultName withDefault:(NSArray *)defaultValue;
- (nullable NSArray *)arrayForKey:(nonnull NSString *)defaultName;

- (void)removeObjectForKey:(NSString *)defaultName;
- (void)deleteAllData;
- (BOOL)commit;

@end