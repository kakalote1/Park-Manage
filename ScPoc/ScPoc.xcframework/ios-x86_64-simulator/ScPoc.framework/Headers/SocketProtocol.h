//
// Created by Williem.T.L on 2021/2/25.
//

#import <Foundation/Foundation.h>

@protocol SocketReceivedPacketDelegate <NSObject>

- (void)dealSocketReceivedPacket:(NSData *)data;

@end

@protocol SocketProtocol <NSObject>

@optional

- (uint16_t)bind:(NSError **)ptrErr;

@required

- (void)updateRemoteHost:(NSString *)host port:(uint16_t)port;

- (BOOL)connect;

- (void)disconnect;

- (void)sendString:(NSString *)str;

- (void)sendData:(NSData *)data head:(uint8_t)headStart;

- (uint16_t)localPort;

@end