//
//  VideoCallViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/6.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "VideoCallViewController.h"
#import <ScPoc/SipSession.h>
#import <ScPoc/SipInviteEvent.h>
#import <ScPoc/SipContext.h>
#import <ScPoc/VideoManager.h>
#import <AVFoundation/AVFoundation.h>
#import <ScPoc/SipSettings.h>

@interface VideoCallViewController ()

@property (strong, nonatomic) SipSession *avSession;

/** 摄像头预览图层 */
@property (nonatomic, strong) UIView *cameraPreviewContainer;
/** 解码预览图层 */
@property (nonatomic, strong) UIView *encodePreviewContainer;

@property (nonatomic, strong) UIView *bigVideoView;
@property (nonatomic, strong) UIView *smallVideoView;

@property (nonatomic, strong) UILabel *stateLbl;
@property (nonatomic, strong) UILabel *telNumberLbl;
@property (nonatomic, strong) UIButton *acceptCallBtn;
@property (nonatomic, strong) UIButton *hangupCallBtn;
@property (nonatomic, strong) UIButton *switchCameraButton;

@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UILabel *hangupLbl;
@property (nonatomic, strong) UILabel *acceptLbl;
@property (nonatomic, strong) UILabel *audioLbl;
@property (nonatomic, strong) UILabel *switchCameraLbl;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGRect panStartVideoFrame;
@end

#define SmallVideoView 120

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f ||[UIScreen mainScreen].bounds.size.height == 844.0f ||[UIScreen mainScreen].bounds.size.height == 926.0f)
#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

@implementation VideoCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bigVideoView = [[UIView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *tapBigVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedBigVideoView:)];
    [self.bigVideoView addGestureRecognizer:tapBigVideo];
    [self.view addSubview:self.bigVideoView];
    
    self.smallVideoView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - SmallVideoView, kStatusBarAndNavigationBarHeight, SmallVideoView, SmallVideoView * 4 /3)];
    [self.smallVideoView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSmallVideoPan:)]];
    [self.smallVideoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSmallVideoTaped:)]];
    [self.view addSubview:self.smallVideoView];
    
    [[self getSipContext].settings setVideoTransUseUdp: FALSE];
    [[self getSipContext].settings setQosPrefVideoSize:1];
    [[self getSipContext].settings setVideoEncoderBitrate:1200];
    if (!self.avSession) {
        self.avSession = [self.getSipContext getCurrentSession];
    }
    if (self.avSession) {
        // 通过判断是呼入还是呼出，改变页面的显示方式
        if ([self.avSession isOutgoing]) {
            // 如果是呼出，改变顶部状态文字显示，并隐藏接听按钮
            self.stateLbl.text = @"正在等待对方接受邀请...";
            self.acceptCallBtn.hidden = YES;
            // 将挂断按钮居中
            self.hangupCallBtn.frame = CGRectMake(self.view.frame.size.width/2-72/2, self.view.frame.size.height - 60 - 72, 72, 72);
        } else {
            // 如果是呼入，显示接听按钮
            self.acceptCallBtn.hidden = NO;
            self.acceptLbl.hidden = NO;
        }
        self.telNumberLbl.hidden = NO;
        self.stateLbl.hidden = NO;
        // 显示挂断按钮
        self.hangupCallBtn.hidden = NO;
        self.hangupLbl.hidden = NO;
        // 设置来电信息
        self.telNumberLbl.text = [self.avSession getRemotePartyDisplayName];
    }
//    self.cameraPreviewContainer.hidden = NO;
//    self.view.layer.contents = self.cameraPreviewContainer;
    [[[self getSipContext] getVideoManager] initWithRemote:self.bigVideoView local:self.smallVideoView];
    self.view.backgroundColor = [UIColor blackColor];
}

// 视图出现前通过通知对页面进行处理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInviteEvent:) name:NOTIFY_NAME_INVITE_EVENT object:nil];
}

// 视图移除前移除通知
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NAME_INVITE_EVENT object:nil];
}

// 根据广播类型做出响应的处理
- (void)handleInviteEvent:(NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    
    // 如果当前回话的sessonId与通知中的sessionId不同直接返回
    if ([self.avSession getId] != event.sessionId) {
        return;
    }

    if (event.eventType == CONNECTED) {
        // 建立通话时更改状态文本并隐藏接听按钮
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.switchCameraButton.hidden = NO;
            self.switchCameraLbl.hidden = NO;
            self.stateLbl.text = @"通话中";
            self.acceptCallBtn.hidden = YES;
            self.acceptLbl.hidden = YES;
            self.audioButton.hidden = NO;
            self.audioLbl.hidden = NO;
            // 将挂断按钮居中
            self.hangupCallBtn.frame = CGRectMake(self.view.frame.size.width/2-72/2, self.view.frame.size.height - 60 - 72, 72, 72);
            self.hangupLbl.frame = CGRectMake(self.view.frame.size.width/2-72/2, self.hangupCallBtn.frame.origin.y + 77, 72, 20);
            self.hangupCallBtn.hidden = NO;
            self.hangupLbl.hidden = NO;
            self.encodePreviewContainer.frame = self.view.bounds;
            self.cameraPreviewContainer.frame = CGRectMake(0.75 * self.view.frame.size.width, self.view.frame.size.height - 50, 0.3 * self.view.frame.size.width, 0.3 * self.view.frame.size.height);
//            self.encodePreviewContainer.hidden = NO;
//            self.cameraPreviewContainer.hidden = NO;
//            [self.encodePreviewContainer addSubview:self.cameraPreviewContainer];
        });
        [[[self getSipContext] getVideoManager] startSocket];
    } else if (event.eventType == TERMINATED) {
        NSLog(@"video TERMINATED");
        [[[self getSipContext] getVideoManager] destroy];
        // 通话结束后关闭当前页面，并清空session
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.avSession = nil;
        
    }
}

// 设置本地视频UIView属性
- (UIView *)cameraPreviewContainer {
    if (!_cameraPreviewContainer) {
        _cameraPreviewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _cameraPreviewContainer.backgroundColor = [UIColor clearColor];
        _cameraPreviewContainer.hidden = YES;
        [self.view addSubview:_cameraPreviewContainer];
    }
    return _cameraPreviewContainer;
}

// 设置对方视频UIView属性
- (UIView *)encodePreviewContainer {
    if (!_encodePreviewContainer) {
        _encodePreviewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _encodePreviewContainer.backgroundColor = [UIColor clearColor];
        _encodePreviewContainer.hidden = YES;
        [self.view addSubview:_encodePreviewContainer];
    }
    return _encodePreviewContainer;
}

// 设置来电号码文本显示属性
- (UILabel *)telNumberLbl {
    if (!_telNumberLbl) {
        _telNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0.067 * self.view.frame.size.height, self.view.frame.size.width / 2, 20)];
        _telNumberLbl.text = @"号码";
        _telNumberLbl.textColor = [UIColor whiteColor];
        _telNumberLbl.textAlignment = NSTextAlignmentLeft;
        _telNumberLbl.font = [UIFont systemFontOfSize:20];
        _telNumberLbl.hidden = YES;
        [self.view addSubview:_telNumberLbl];
    }
    return _telNumberLbl;
}

// 设置状态文本显示属性
- (UILabel *)stateLbl {
    if (!_stateLbl) {
        _stateLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.telNumberLbl.frame.origin.y + 30, self.view.frame.size.width / 2, 20)];
        _stateLbl.text = @"正在邀请你进行视频通话...";
        _stateLbl.textColor = [UIColor whiteColor];
        _stateLbl.textAlignment = NSTextAlignmentLeft;
        _stateLbl.font = [UIFont systemFontOfSize:15];
        _stateLbl.hidden = YES;
        [self.view addSubview:_stateLbl];
    }
    return _stateLbl;
}

// 设置接听按钮属性
- (UIButton *)hangupCallBtn {
    if (!_hangupCallBtn) {
        _hangupCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(79, self.view.frame.size.height - 60 - 72, 72, 72)];
        [_hangupCallBtn setBackgroundImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateNormal];
        [_hangupCallBtn setBackgroundImage:[UIImage imageNamed:@"hangup_hover"] forState:UIControlStateHighlighted];
        [_hangupCallBtn setBackgroundImage:[UIImage imageNamed:@"hangup_hover"] forState:UIControlStateSelected];
        [_hangupCallBtn setBackgroundColor:[UIColor clearColor]];
        [_hangupCallBtn addTarget:self action:@selector(hangupButtonDidTap:) forControlEvents:UIControlEventTouchDown];
        _hangupCallBtn.hidden = YES;
        [self.view addSubview:_hangupCallBtn];
    }
    return _hangupCallBtn;
}

// 设置挂断label属性
- (UILabel *)hangupLbl {
    if (!_hangupLbl) {
        _hangupLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.hangupCallBtn.frame.origin.x, self.hangupCallBtn.frame.origin.y + 77, 72, 20)];
        _hangupLbl.text = @"挂断";
        _hangupLbl.textColor = [UIColor whiteColor];
        _hangupLbl.textAlignment = NSTextAlignmentCenter;
        _hangupLbl.font = [UIFont systemFontOfSize:13];
        _hangupLbl.hidden = YES;
        [self.view addSubview:_hangupLbl];
    }
    return _hangupLbl;
}

// 设置接听按钮属性
- (UIButton *)acceptCallBtn {
    if (!_acceptCallBtn) {
        _acceptCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 79 - 72, self.view.frame.size.height - 60 - 72, 72, 72)];
        [_acceptCallBtn setBackgroundImage:[UIImage imageNamed:@"video_answer"] forState:UIControlStateNormal];
        [_acceptCallBtn setBackgroundImage:[UIImage imageNamed:@"video_answer_hover"] forState:UIControlStateHighlighted];
        [_acceptCallBtn setBackgroundImage:[UIImage imageNamed:@"video_answer_hover"] forState:UIControlStateSelected];
        [_acceptCallBtn setBackgroundColor:[UIColor clearColor]];
        [_acceptCallBtn addTarget:self action:@selector(acceptButtonDidTap:) forControlEvents:UIControlEventTouchDown];
        _acceptCallBtn.hidden = YES;
        [self.view addSubview:_acceptCallBtn];
        }
    return _acceptCallBtn;
}

// 设置接听label属性
- (UILabel *)acceptLbl {
   if (!_acceptLbl) {
       _acceptLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.acceptCallBtn.frame.origin.x, self.acceptCallBtn.frame.origin.y + 75, 72, 20)];
       _acceptLbl.text = @"接听";
       _acceptLbl.textColor = [UIColor whiteColor];
       _acceptLbl.textAlignment = NSTextAlignmentCenter;
       _acceptLbl.font = [UIFont systemFontOfSize:13];
       _acceptLbl.hidden = YES;
       [self.view addSubview:_acceptLbl];
   }
   return _acceptLbl;
}
   
// 设置切换摄像头按钮属性
- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-72*3)/4 + 36 + (self.view.frame.size.width/2), self.hangupCallBtn.frame.origin.y, 72, 72)];
        [_switchCameraButton setBackgroundImage:[UIImage imageNamed:@"switchcamera"] forState:UIControlStateNormal];
        [_switchCameraButton setBackgroundImage:[UIImage imageNamed:@"switchcamera_hover"] forState:UIControlStateHighlighted];
        [_switchCameraButton setBackgroundImage:[UIImage imageNamed:@"switchcamera_hover"] forState:UIControlStateSelected];
        [_switchCameraButton setBackgroundColor:[UIColor clearColor]];
        [_switchCameraButton addTarget:self action:@selector(switchCameraButtonDidTap:) forControlEvents:UIControlEventTouchDown];
        _switchCameraButton.hidden = YES;
        [self.view addSubview:_switchCameraButton];
    }
    return _switchCameraButton;
}

// 设置切换摄像头label属性
- (UILabel *)switchCameraLbl {
    if (!_switchCameraLbl) {
        _switchCameraLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.switchCameraButton.frame.origin.x, self.switchCameraButton.frame.origin.y + 75, 72, 20)];
        _switchCameraLbl.text = @"切换摄像头";
        _switchCameraLbl.textColor = [UIColor whiteColor];
        _switchCameraLbl.textAlignment = NSTextAlignmentCenter;
        _switchCameraLbl.font = [UIFont systemFontOfSize:13];
        _switchCameraLbl.hidden = YES;
        [self.view addSubview:_switchCameraLbl];
    }
    return _switchCameraLbl;
}

// 设置音频按钮属性
- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-72*3)/4, self.hangupCallBtn.frame.origin.y, 72, 72)];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute_hover"] forState:UIControlStateHighlighted];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute_hover"] forState:UIControlStateSelected];
        [_audioButton setBackgroundColor:[UIColor clearColor]];
        [_audioButton addTarget:self action:@selector(audioButtonDidTap:) forControlEvents:UIControlEventTouchDown];
        _audioButton.hidden = YES;
        [self.view addSubview:_audioButton];
    }
    return _audioButton;
}

// 设置音频label属性
- (UILabel *)audioLbl {
    if (!_audioLbl) {
        _audioLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-72*3)/4, self.hangupCallBtn.frame.origin.y + 77, 72, 20)];
        _audioLbl.text = @"关闭麦克风";
        _audioLbl.font = [UIFont systemFontOfSize:13];
        _audioLbl.textAlignment = NSTextAlignmentCenter;
        _audioLbl.textColor = [UIColor whiteColor];
        _audioLbl.hidden = YES;
        [self.view addSubview:_audioLbl];
    }
    return _audioLbl;
}

// 挂断按钮绑定事件
- (void)hangupButtonDidTap:(UIButton *)button {
    [self.avSession hangupCall:@"AudioCall click hangup"];
    [[[self getSipContext] getVideoManager] destroy];
}

// 接听按钮绑定事件
- (void)acceptButtonDidTap:(UIButton *)button {
    [[self.getSipContext getCurrentSession] acceptCall];
}

// 切换摄像头按钮绑定事件
- (void)switchCameraButtonDidTap:(UIButton *)button {
    [[[self getSipContext] getVideoManager] toggleCamera];
}

- (void)onClickedBigVideoView:(NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    if (event.eventType != CONNECTED) {
        return;
    }
    if (self.smallVideoView.hidden) {
        if (self.hangupCallBtn.hidden) {
            self.hangupCallBtn.hidden = NO;
            self.hangupLbl.hidden = NO;
            self.switchCameraLbl.hidden = NO;
            self.switchCameraButton.hidden = NO;
            self.audioButton.hidden = NO;
            self.audioLbl.hidden = NO;
            self.stateLbl.hidden = NO;
            self.telNumberLbl.hidden = NO;
            self.smallVideoView.hidden = NO;
        } else {
            self.hangupCallBtn.hidden = YES;
            self.hangupLbl.hidden = YES;
            self.switchCameraLbl.hidden = YES;
            self.switchCameraButton.hidden = YES;
            self.audioButton.hidden = YES;
            self.audioLbl.hidden = YES;
            self.stateLbl.hidden = YES;
            self.telNumberLbl.hidden = YES;
        }
    } else {
        self.smallVideoView.hidden = YES;
    }
}

- (void)setPanStartPoint:(CGPoint)panStartPoint {
    _panStartPoint = panStartPoint;
    _panStartVideoFrame = self.smallVideoView.frame;
}

- (void)moveToPanPoint:(CGPoint)panPoint {
    CGRect frame = self.panStartVideoFrame;
    CGSize moveSize = CGSizeMake(panPoint.x - self.panStartPoint.x, panPoint.y - self.panStartPoint.y);
    
    frame.origin.x += moveSize.width;
    frame.origin.y += moveSize.height;
    self.smallVideoView.frame = frame;
}

- (void)onSmallVideoPan:(UIPanGestureRecognizer *)recognize {
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognize translationInView:self.view];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognize translationInView:self.view];
            [self moveToPanPoint:currentPoint];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint endPoint = [recognize translationInView:self.view];
            [self moveToPanPoint:endPoint];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            break;
        }
}

- (void)onSmallVideoTaped:(NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    if (event.eventType == CONNECTED) {
        Boolean flag = TRUE;
        if (flag) {
            [[[self getSipContext] getVideoManager] initWithRemote:self.smallVideoView local:self.bigVideoView];
            flag = FALSE;
        } else {
            [[[self getSipContext] getVideoManager] initWithRemote:self.bigVideoView local:self.smallVideoView];
        }
    }
}

// 开关麦克风按钮绑定事件
- (void)audioButtonDidTap:(UIButton *)button {
    // 开关麦克风
    
    // 更新按钮状态
    [self updateAudioButton];
}

// 根据系统麦克风状态更新按钮状态
-(void)updateAudioButton {
    
}

- (void)setAvSession:(SipSession *)avSession {
    _avSession = avSession;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    if (instance == nil) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}

+ (instancetype)sharedPerson
{
    return [self new];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
