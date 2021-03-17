//
// Created by Williem.T.L on 2021/1/23.
//

#import <Foundation/Foundation.h>

#define OBJC_STR(str) @""#str""

/*
 * Error utilities.
 */
/** Raise Error exception */
#define SCSIP_RAISE_ERROR(status) SCSIP_RAISE_ERROR2(status, __FUNCTION__)
/** Raise Error exception */
#define SCSIP_RAISE_ERROR2(status, op) SCSIP_RAISE_ERROR3(status, op, "")
/** Raise Error exception */
#define SCSIP_RAISE_ERROR3(status, op, pchReason) \
    do { \
        NSLog(@"ERROR method: %@, status=%d %s, File %s.%s(line:%d)", \
        op, status, pchReason, __FILE__, __FUNCTION__, __LINE__); \
    } while (0)
//#define SCSIP_RAISE_ERROR3(status, op, pchReason) \
//    do { \
//        uint32_t exceptStatus = (status); \
//        NSString *exceptOp = [NSString stringWithCString:(op) encoding:NSUTF8StringEncoding]; \
//        NSString *exceptReason = [NSString stringWithFormat:@"method: %@, status=%d %s, File %s.%s(line:%d)", \
//            exceptOp, exceptStatus, pchReason, __FILE__, __FUNCTION__, __LINE__]; \
//        @throw [NSException exceptionWithName:exceptOp reason:exceptReason userInfo:nil]; \
//    } while (0)
/** Raise Error exception if the status fails */
#define SCSIP_CHECK_RAISE_ERROR(status) \
    PJSUA2_CHECK_RAISE_ERROR2(status, "")
/** Raise Error exception if the expression fails */
#define SCSIP_CHECK_RAISE_ERROR2(status, op) \
    do { \
        if (status != PJ_SUCCESS) { \
            SCSIP_RAISE_ERROR2(status, op); \
        } \
    } while (0)
/** Raise Error exception if the expression fails */
#define SCSIP_CHECK_EXPR(expr) \
    do { \
        pj_status_t the_status = expr; \
        SCSIP_CHECK_RAISE_ERROR2(the_status, OBJC_STR(expr)); \
    } while (0)


#define PJ2BOOL(var) ((var) != PJ_FALSE)

#define FILENAME(x) (strrchr(x,'/')?strrchr(x,'/')+1:x)

#define SCLog(format, ...) NSLog(@"%s.%s(line:%d): " format, FILENAME(__FILE__), __FUNCTION__, __LINE__, ##__VA_ARGS__ )

#define LOG_CRASH(info, e) SCLog(@"CRASH info: %@, except: %@\nStack Trace: %@", info, e, [e callStackSymbols])

/**
 * sip protocol status code
 */
typedef NS_ENUM(NSInteger, SipStatusCode) {
    SCSIP_SC_TRYING = 100,
    SCSIP_SC_RINGING = 180,
    SCSIP_SC_CALL_BEING_FORWARDED = 181,
    SCSIP_SC_QUEUED = 182,
    SCSIP_SC_PROGRESS = 183,

    SCSIP_SC_OK = 200,
    SCSIP_SC_ACCEPTED = 202,

    SCSIP_SC_MULTIPLE_CHOICES = 300,
    SCSIP_SC_MOVED_PERMANENTLY = 301,
    SCSIP_SC_MOVED_TEMPORARILY = 302,
    SCSIP_SC_USE_PROXY = 305,
    SCSIP_SC_ALTERNATIVE_SERVICE = 380,

    SCSIP_SC_BAD_REQUEST = 400,
    SCSIP_SC_UNAUTHORIZED = 401,
    SCSIP_SC_PAYMENT_REQUIRED = 402,
    SCSIP_SC_FORBIDDEN = 403,
    SCSIP_SC_NOT_FOUND = 404,
    SCSIP_SC_METHOD_NOT_ALLOWED = 405,
    SCSIP_SC_NOT_ACCEPTABLE = 406,
    SCSIP_SC_PROXY_AUTHENTICATION_REQUIRED = 407,
    SCSIP_SC_REQUEST_TIMEOUT = 408,
    SCSIP_SC_GONE = 410,
    SCSIP_SC_REQUEST_ENTITY_TOO_LARGE = 413,
    SCSIP_SC_REQUEST_URI_TOO_LONG = 414,
    SCSIP_SC_UNSUPPORTED_MEDIA_TYPE = 415,
    SCSIP_SC_UNSUPPORTED_URI_SCHEME = 416,
    SCSIP_SC_BAD_EXTENSION = 420,
    SCSIP_SC_EXTENSION_REQUIRED = 421,
    SCSIP_SC_SESSION_TIMER_TOO_SMALL = 422,
    SCSIP_SC_INTERVAL_TOO_BRIEF = 423,
    SCSIP_SC_TEMPORARILY_UNAVAILABLE = 480,
    SCSIP_SC_CALL_TSX_DOES_NOT_EXIST = 481,
    SCSIP_SC_LOOP_DETECTED = 482,
    SCSIP_SC_TOO_MANY_HOPS = 483,
    SCSIP_SC_ADDRESS_INCOMPLETE = 484,
    SCSIP_AC_AMBIGUOUS = 485,
    SCSIP_SC_BUSY_HERE = 486,
    SCSIP_SC_REQUEST_TERMINATED = 487,
    SCSIP_SC_NOT_ACCEPTABLE_HERE = 488,
    SCSIP_SC_BAD_EVENT = 489,
    SCSIP_SC_REQUEST_UPDATED = 490,
    SCSIP_SC_REQUEST_PENDING = 491,
    SCSIP_SC_UNDECIPHERABLE = 493,

    SCSIP_SC_INTERNAL_SERVER_ERROR = 500,
    SCSIP_SC_NOT_IMPLEMENTED = 501,
    SCSIP_SC_BAD_GATEWAY = 502,
    SCSIP_SC_SERVICE_UNAVAILABLE = 503,
    SCSIP_SC_SERVER_TIMEOUT = 504,
    SCSIP_SC_VERSION_NOT_SUPPORTED = 505,
    SCSIP_SC_MESSAGE_TOO_LARGE = 513,
    SCSIP_SC_PRECONDITION_FAILURE = 580,

    SCSIP_SC_BUSY_EVERYWHERE = 600,
    SCSIP_SC_DECLINE = 603,
    SCSIP_SC_DOES_NOT_EXIST_ANYWHERE = 604,
    SCSIP_SC_NOT_ACCEPTABLE_ANYWHERE = 606,

    SCSIP_SC_TSX_TIMEOUT = SCSIP_SC_REQUEST_TIMEOUT,
    /*SCSIP_SC_TSX_RESOLVE_ERROR = 702,*/
            SCSIP_SC_TSX_TRANSPORT_ERROR = SCSIP_SC_SERVICE_UNAVAILABLE,

    /* This is not an actual status code, but rather a constant
     * to force GCC to use 32bit to represent this enum, since
     * we have a code in PJSUA-LIB that assigns an integer
     * to this enum (see pjsua_acc_get_info() function).
     */
            SCSIP_SC__force_32bit = 0x7FFFFFFF

};

/**
 * This enumeration describes invite session state.
 */
typedef NS_ENUM(NSInteger, SipInvState){
    SIP_INV_STATE_NULL,	    /**< Before INVITE is sent or received  */
    SIP_INV_STATE_CALLING,	    /**< After INVITE is sent		    */
    SIP_INV_STATE_INCOMING,	    /**< After INVITE is received.	    */
    SIP_INV_STATE_EARLY,	    /**< After response with To tag.	    */
    SIP_INV_STATE_CONNECTING,	    /**< After 2xx is sent/received.	    */
    SIP_INV_STATE_CONFIRMED,	    /**< After ACK is sent/received.	    */
    SIP_INV_STATE_DISCONNECTED,   /**< Session is terminated.		    */
};

/**
 * make call check state
 */
typedef NS_ENUM(NSInteger, SipOutgoingCallState) {
    SipOutgoingCallStateSuccess,
    SipOutgoingCallStateInvalidTel,
    SipOutgoingCallStateUnregistered,
    SipOutgoingCallStateCallSelfTel
};

/**
 * call status
 */
typedef NS_ENUM(NSInteger, SipCallStatus) {
    SipCallStatusBeforeSdp,
    SipCallStatusBeforeConnected,
    SipCallStatusInCalling,
    SipCallStatusHangup
};

/**
 * Transaction role.
 */
typedef NS_ENUM(NSInteger, SipRole) {
    SIP_ROLE_UAC,	/**< Role is UAC. */
    SIP_ROLE_UAS,	/**< Role is UAS. */

    /* Alias: */

    SIP_UAC_ROLE = SIP_ROLE_UAC,	/**< Role is UAC. */
    SIP_UAS_ROLE = SIP_ROLE_UAS	/**< Role is UAS. */

};

/**
 * This enumeration represents transaction state.
 */
typedef NS_ENUM(NSInteger, SipTsxState) {
    SIP_TSX_STATE_NULL,	/**< For UAC, before any message is sent.   */
    SIP_TSX_STATE_CALLING,	/**< For UAC, just after request is sent.   */
    SIP_TSX_STATE_TRYING,	/**< For UAS, just after request is received.*/
    SIP_TSX_STATE_PROCEEDING,	/**< For UAS/UAC, after provisional response.*/
    SIP_TSX_STATE_COMPLETED,	/**< For UAS/UAC, after final response.	    */
    SIP_TSX_STATE_CONFIRMED,	/**< For UAS, after ACK is received.	    */
    SIP_TSX_STATE_TERMINATED,	/**< For UAS/UAC, before it's destroyed.    */
    SIP_TSX_STATE_DESTROYED,	/**< For UAS/UAC, will be destroyed now.    */
    SIP_TSX_STATE_MAX		/**< Number of states.			    */
};

/**
 * Media direction.
 */
typedef NS_ENUM(NSInteger, MediaDir) {
    /** None */
    MEDIA_DIR_NONE = 0,
    /** Encoding (outgoing to network) stream, also known as capture */
    MEDIA_DIR_ENCODING = 1,
    /** Same as encoding direction. */
    MEDIA_DIR_CAPTURE = MEDIA_DIR_ENCODING,
    /** Decoding (incoming from network) stream, also known as playback. */
    MEDIA_DIR_DECODING = 2,
    /** Same as decoding. */
    MEDIA_DIR_PLAYBACK = MEDIA_DIR_DECODING,
    /** Same as decoding. */
    MEDIA_DIR_RENDER = MEDIA_DIR_DECODING,
    /** Incoming and outgoing stream, same as PJMEDIA_DIR_CAPTURE_PLAYBACK */
    MEDIA_DIR_ENCODING_DECODING = 3,
    /** Same as ENCODING_DECODING */
    MEDIA_DIR_CAPTURE_PLAYBACK = MEDIA_DIR_ENCODING_DECODING,
    /** Same as ENCODING_DECODING */
    MEDIA_DIR_CAPTURE_RENDER = MEDIA_DIR_ENCODING_DECODING
};

/**
 * This enumeration specifies the media status of a call, and it's part
 * of pjsua_call_info structure.
 */
typedef NS_ENUM(NSInteger, SipCallMediaStatus) {
    /**
     * Call currently has no media, or the media is not used.
     */
    SIP_CALL_MEDIA_NONE,

    /**
     * The media is active
     */
    SIP_CALL_MEDIA_ACTIVE,

    /**
     * The media is currently put on hold by local endpoint
     */
    SIP_CALL_MEDIA_LOCAL_HOLD,

    /**
     * The media is currently put on hold by remote endpoint
     */
    SIP_CALL_MEDIA_REMOTE_HOLD,

    /**
     * The media has reported error (e.g. ICE negotiation)
     */
    SIP_CALL_MEDIA_ERROR
};

@interface SipTypes : NSObject
@end
