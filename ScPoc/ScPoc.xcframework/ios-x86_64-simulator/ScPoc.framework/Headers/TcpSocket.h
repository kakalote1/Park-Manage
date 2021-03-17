//
// Created by Williem.T.L on 2021/2/23.
//

#import <Foundation/Foundation.h>

#define PACKAGE_HDR_START_INFO ((uint8_t)0xF5)
#define PACKAGE_HDR_START_STREAM ((uint8_t)0x24)

@protocol SocketProtocol;

@protocol SocketReceivedPacketDelegate;

@interface TcpSocket : NSObject <SocketProtocol>

@property (strong, nonatomic) NSString *host;

@property (nonatomic) uint16_t port;

@property (strong, nonatomic) id<SocketReceivedPacketDelegate> receivedPacketDelegate;

@end
