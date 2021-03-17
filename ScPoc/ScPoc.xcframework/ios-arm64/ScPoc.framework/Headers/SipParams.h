//
// Created by Williem.T.L on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import "SipRxData.h"
#import "SipEvent.h"
#import "SdpSession.h"
#import "Media.h"

@interface SipParams : NSObject
@end

#pragma mark - pjsua call option param

/**
 * This structure contains parameters for Call::answer(), Call::hangup(),
 * Call::reinvite(), Call::update(), Call::xfer(), Call::xferReplaces(),
 * Call::setHold().
 */
@interface CallOpParam : NSObject
/**
 * Status code.
 */
@property (nonatomic) SipStatusCode statusCode;
/**
 * Reason phrase.
 */
@property (strong, nonatomic) NSString *reason;
/**
 * Options.
 */
@property (nonatomic) unsigned options;

- (instancetype)init:(SipStatusCode)statusCode;
- (instancetype)init:(SipStatusCode)statusCode reason:(NSString *)reason;
- (instancetype)initOp:(unsigned)options;
@end

#pragma mark - pjsua callback param

/**
 * This structure contains parameters for onRegStarted() account callback.
 */
@interface OnRegStartedParam : NSObject

/**
 * True for registration and False for unregistration.
 */
@property (nonatomic) BOOL renew;
@end

/**
 * This structure contains parameters for onRegState() account callback.
 */
@interface OnRegStateParam : NSObject
/**
 * Registration operation status.
 */
@property (nonatomic) int		        status;

/**
 * SIP status code received.
 */
@property (nonatomic) int32_t	        code;

/**
 * SIP reason phrase received.
 */
@property (strong, nonatomic) NSString  *reason;

/**
 * The incoming message.
 */
@property (strong, nonatomic) SipRxData *rdata;

/**
 * Next expiration interval.
 */
@property (nonatomic) int			    expiration;
@end

/**
 * This structure contains parameters for onIncomingCall() account callback.
 */
@interface OnIncomingCallParam : NSObject
/**
 * The library call ID allocated for the new call.
 */
@property (nonatomic) int               callId;
/**
 * The remote phone number of the new call.
 */
@property (strong, nonatomic) NSString *remoteNumber;
/**
 * The Call-ID of The incoming INVITE request.
 */
@property (strong, nonatomic) NSString *callIdString;

/**
 * The incoming INVITE request.
 */
@property (strong, nonatomic) SipRxData *rdata;
@end

#pragma mark - call callback param

/**
 * This structure contains parameters for Call::onCallState() callback.
 */
@interface OnCallStateParam : NSObject
/**
 * Event which causes the call state to change.
 */
@property (strong, nonatomic) SipEvent *e;
@end

/**
* This structure contains parameters for Call::onCallTsxState() callback.
*/
@interface OnCallTsxStateParam : NSObject
/**
 * Transaction event that caused the state change.
 */
@property (strong, nonatomic) SipEvent *e;
@end

/**
 * This structure contains parameters for Call::onCallSdpCreated() callback.
 */
@interface OnCallSdpCreatedParam : NSObject
/**
 * The SDP has just been created.
 */
@property (strong, nonatomic) SdpSession *sdp;

/**
 * The remote SDP, will be empty if local is SDP offerer.
 */
@property (strong, nonatomic) SdpSession *remSdp;
@end

/**
 * Media stream, corresponds to pjmedia_stream
 */
typedef void *MediaStream;

/**
 * This structure contains parameters for Call::onStreamCreated()
 * callback.
 */
@interface OnStreamCreatedParam : NSObject
/**
 * Media stream, read-only.
 */
@property (nonatomic) MediaStream stream;

/**
 * Stream index in the media session, read-only.
 */
@property (nonatomic) unsigned streamIdx;

/**
 * Specify if PJSUA2 should take ownership of the port returned in
 * the pPort parameter below. If set to PJ_TRUE,
 * pjmedia_port_destroy() will be called on the port when it is
 * no longer needed.
 *
 * Default: PJ_FALSE
 */
@property (nonatomic) BOOL destroyPort;

/**
 * On input, it specifies the media port of the stream. Application
 * may modify this pointer to point to different media port to be
 * registered to the conference bridge.
 */
@property (nonatomic) MediaPort pPort;
@end

/**
 * This structure contains parameters for Call::onStreamDestroyed()
 * callback.
 */
@interface OnStreamDestroyedParam : NSObject
/**
 * Media stream.
 */
@property (nonatomic) MediaStream stream;

/**
 * Stream index in the media session.
 */
@property (nonatomic) unsigned streamIdx;
@end

@interface OnTransDataParam : NSObject
@property (strong, nonatomic) NSString *data;
@end
