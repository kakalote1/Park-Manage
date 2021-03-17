//
// Created by Williem.T.L on 2021/2/25.
//

#import <Foundation/Foundation.h>

@protocol SocketProtocol;

@protocol SocketReceivedPacketDelegate;


@interface UdpSocket : NSObject <SocketProtocol>

@property (strong, nonatomic) NSString *host;

@property (nonatomic) uint16_t port;

@property (strong, nonatomic) id<SocketReceivedPacketDelegate> receivedPacketDelegate;

@end