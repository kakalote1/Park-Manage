//
//  AudioCallViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/2/1.
//  Copyright © 2021 LGD_Sunday. All rights reserved.
//

#import "AudioCallViewController.h"
#import <ScPoc/SipSession.h>
#import <ScPoc/SipInviteEvent.h>
#import "UIView+Toast.h"
#import "HttpManager.h"




@interface AudioCallViewController ()

@property (strong, nonatomic) SipSession *avSession;

@property (strong, nonatomic) UILabel *telNumberLbl;
@property (strong, nonatomic) UILabel *stateLbl;
@property (strong, nonatomic)  UIButton *acceptCallBtn;
@property (strong, nonatomic)  UIButton *hangupCallBtn;

@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UILabel *hangupLbl;
@property (nonatomic, strong) UILabel *acceptLbl;
@property (nonatomic, strong) UILabel *speakerLbl;
@property (nonatomic, strong) UILabel *audioLbl;
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *telNameLbl;

@property (nonatomic, strong) AVAudioSession *avAudioSession;

@property (nonatomic, strong) NSString *memName;


@end

@implementation AudioCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    self.avAudioSession = [AVAudioSession sharedInstance];

    
    UIImage *img = [UIImage imageNamed:@"background"];
    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(self.view.frame.size.width, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    UIImage *newImg = [img resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    self.view.layer.contents = (__bridge id _Nullable)(img.CGImage);
    _portraitView = [[UIImageView alloc] init];
    [self.portraitView setImage:[UIImage imageNamed:@"PersonalChat"]];
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.layer.cornerRadius = 10.0f;
    self.portraitView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.portraitView.layer.borderWidth = 1.0;
    self.portraitView.frame = CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.height / 4, self.view.frame.size.width / 3, self.view.frame.size.width / 3);
//    [self.view addSubview:self.portraitView];
    self.telNameLbl.hidden = NO;
    self.telNumberLbl.hidden = NO;
    self.stateLbl.hidden = NO;
    // 获取当前呼叫的session
    if (!self.avSession) {
        self.avSession = [self.getSipContext getCurrentSession];
    }
    if (self.avSession) {
        NSString *url = @"http://58.220.201.130:12383/zlw/data/thirdPartLogin/getMemberInfoByTel";
        NSString *tel = [self.avSession getRemotePartyDisplayName];
        NSLog(@"tel : %@", tel);
        self.telNumberLbl.text = tel;
        if (![tel isEqualToString: @"998"]) {
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSDictionary *param = @{@"uid": uid, @"tel": tel};
            NSLog(@"avsession: %@", [self.avSession getRemotePartyDisplayName]);
            [[HttpManager shareInstance] getRequestWithUrl:url andParam:param andHeaders:nil andSuccess:^(id responseObject) {
                NSDictionary *data = responseObject[@"data"];

                self.memName = data[@"memName"];
                NSLog(@"telInfo: %@", self.memName);
                self.telNameLbl.text = data[@"memName"];

                } andFail:^(id error) {
                    
                }];
        } else {
            self.telNameLbl.text = @"音频会议";
        }
      
        if ([self.avSession isOutgoing]) {
            // 通过判断是呼入还是呼出，改变顶部状态文本的文字显示
            self.stateLbl.text = @"去电";
            // 通过判断是呼入还是呼出隐藏接听按钮
            self.acceptCallBtn.hidden = YES;
            self.acceptLbl.hidden = YES;
            // 将挂断按钮居中
            self.hangupCallBtn.frame = CGRectMake(self.view.frame.size.width/2-72/2, self.view.frame.size.height - 60 - 72, 72, 72);
        } else {
            self.stateLbl.text = @"来电";
            self.acceptCallBtn.hidden = NO;
            self.acceptLbl.hidden = NO;
        }
        self.hangupCallBtn.hidden = NO;
        self.hangupLbl.hidden = NO;
        // 获取当前呼叫的对端号码
    }
}

// 视图出现前通过通知对页面进行处理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInviteEvent:) name:NOTIFY_NAME_INVITE_EVENT object:nil];
}

// 视图移除前移除通知
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NAME_INVITE_EVENT object:nil];
}

//// 视图被销毁后清空sipSession
//- (void)dealloc {
//    self.avSession = nil;
//}



- (void)hangupButtonDidTap:(UIButton *) button {
    // 向服务器发送通话结束请求
    [self.avSession hangupCall:@"AudioCall click hangup"];
    // 通话结束后关闭当前页面，并清空session
    dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)acceptButtonDidTap:(UIButton *) button {
    // 向服务器发送应答请求
    [self.avSession acceptCall];
}

- (void)handleInviteEvent:(NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    
    // 如果当前回话的sessonId与通知中的sessionId不同直接返回
    if ([self.avSession getId] != event.sessionId) {
        return;
    }
    
    if (event.eventType == CONNECTING) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"正在连接" duration:0.5 position:CSToastPositionDown];
        });
    }

    if (event.eventType == CONNECTED) {
        // 建立通话时更改状态文本并隐藏接听按钮
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"已接通" duration:1.0 position:CSToastPositionDown];
            self.stateLbl.text = @"通话中";
            self.acceptCallBtn.hidden = YES;
            self.acceptCallBtn.hidden = YES;
            self.acceptLbl.hidden = YES;
            self.speakerButton.hidden = NO;
            self.speakerLbl.hidden = NO;
            self.audioButton.hidden = NO;
            self.audioLbl.hidden = NO;
            // 将挂断按钮居中
            self.hangupCallBtn.frame = CGRectMake(self.view.frame.size.width/2-72/2, self.view.frame.size.height - 60 - 72, 72, 72);
            self.hangupLbl.frame = CGRectMake(self.view.frame.size.width/2-72/2, self.hangupCallBtn.frame.origin.y + 77, 72, 20);
        });
    }
    else if (event.eventType == TERMINATED) {
        NSLog(@"接收到挂断通知");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"再次接收到挂断通知");
            [self.view makeToast:@"已挂断" duration:1.0 position:CSToastPositionDown];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        // 通话结束后关闭当前页面，并清空session
        self.avSession = nil;
    }
}

- (UILabel *)telNameLbl {
    if (!_telNameLbl) {
        _telNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 8, self.view.frame.size.width, 25)];
        _telNameLbl.textColor = [UIColor whiteColor];
        _telNameLbl.textAlignment = NSTextAlignmentCenter;
        _telNameLbl.font = [UIFont systemFontOfSize:25];
        _telNameLbl.hidden = YES;
        [self.view addSubview:_telNameLbl];
    }
    return _telNameLbl;
}

- (UILabel *)telNumberLbl {
    if (!_telNumberLbl) {
        _telNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.telNameLbl.frame.origin.y + 40, self.view.frame.size.width, 20)];
        _telNumberLbl.textColor = [UIColor whiteColor];
        _telNumberLbl.textAlignment = NSTextAlignmentCenter;
        _telNumberLbl.font = [UIFont systemFontOfSize:20];
        _telNumberLbl.hidden = YES;
        [self.view addSubview:_telNumberLbl];
    }
    return _telNumberLbl;
}

- (UILabel *)stateLbl {
    if (!_stateLbl) {
        _stateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.telNumberLbl.frame.origin.y + 35, self.view.frame.size.width, 20)];
        _stateLbl.textColor = [UIColor whiteColor];
        _stateLbl.textAlignment = NSTextAlignmentCenter;
        _stateLbl.font = [UIFont systemFontOfSize:15];
        _stateLbl.hidden = YES;
        [self.view addSubview:_stateLbl];
    }
    return _stateLbl;
}

// 设置接听按钮属性
- (UIButton *)acceptCallBtn {
    if (!_acceptCallBtn) {
        _acceptCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 79 - 72, self.view.frame.size.height - 60 - 72, 72, 72)];
        [_acceptCallBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
        [_acceptCallBtn setBackgroundImage:[UIImage imageNamed:@"answer_hover"] forState:UIControlStateHighlighted];
        [_acceptCallBtn setBackgroundImage:[UIImage imageNamed:@"answer_hover"] forState:UIControlStateSelected];
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


- (UIButton *)hangupCallBtn {
    if (!_hangupCallBtn) {
        _hangupCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(79, self.view.frame.size.height - 60 - 72, 72, 72)];
        [_hangupCallBtn setBackgroundImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateNormal];
        [_hangupCallBtn setBackgroundImage:[UIImage imageNamed:@"hangup_hover"] forState:UIControlStateHighlighted];
        [_hangupCallBtn setBackgroundImage:[UIImage imageNamed:@"hangup_hover"] forState:UIControlStateSelected];
        [_hangupCallBtn setBackgroundColor:[UIColor clearColor]];
        [_hangupCallBtn addTarget:self action:@selector(hangupButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
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

// 设置扬声器按钮属性
- (UIButton *)speakerButton {
    if (!_speakerButton) {
        _speakerButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-72*3)/4 + 36 + (self.view.frame.size.width/2), self.hangupCallBtn.frame.origin.y, 72, 72)];
        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker_hover"] forState:UIControlStateHighlighted];
        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker_hover"] forState:UIControlStateSelected];
        [_speakerButton setBackgroundColor:[UIColor clearColor]];
        [_speakerButton addTarget:self action:@selector(speakerButtonDidTap:) forControlEvents:UIControlEventTouchDown];
        _speakerButton.hidden = YES;
        [self.view addSubview:_speakerButton];
    }
    return _speakerButton;
}

// 设置扬声器label属性
- (UILabel *)speakerLbl {
    if (!_speakerLbl) {
        _speakerLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-72*3)/4 + 36 + (self.view.frame.size.width/2), self.hangupCallBtn.frame.origin.y + 77, 72, 20)];
        _speakerLbl.text = @"免提";
        _speakerLbl.textColor = [UIColor whiteColor];
        _speakerLbl.textAlignment = NSTextAlignmentCenter;
        _speakerLbl.font = [UIFont systemFontOfSize:13];
        _speakerLbl.hidden = YES;
        [self.view addSubview:_speakerLbl];
    }
    return _speakerLbl;
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
//        [self updateAudioButton];
        [self.view addSubview:_audioButton];
    }
    return _audioButton;
}

// 设置音频label属性
- (UILabel *)audioLbl {
    if (!_audioLbl) {
        _audioLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-72*3)/4, self.hangupCallBtn.frame.origin.y + 77, 72, 20)];
        _audioLbl.text = @"静音";
        _audioLbl.font = [UIFont systemFontOfSize:13];
        _audioLbl.textAlignment = NSTextAlignmentCenter;
        _audioLbl.textColor = [UIColor whiteColor];
        _audioLbl.hidden = YES;
        [self.view addSubview:_audioLbl];
    }
    return _audioLbl;
}

// 扬声器按钮点击事件
- (void)speakerButtonDidTap:(UIButton *)button {
    // 开关扬声器
    if ([[self getSipContext] isSpeakerphoneOn]) {
        [[self getSipContext] setSpeakerphoneOn:NO];
        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];

    } else {
        [[self getSipContext] setSpeakerphoneOn:YES];
        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker_hover"] forState:UIControlStateNormal];

    }
    // 更新按钮状态
//    [self updateSpeakerButton];
}

// 根据系统扬声器状态更新按钮状态
//-(void)updateSpeakerButton {
//    if ([[self getSipContext] isSpeakerphoneOn]) {
//        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker_hover"] forState:UIControlStateNormal];
//    } else {
//        [_speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
//    }
//}

// 麦克风静音按钮点击事件
- (void)audioButtonDidTap:(UIButton *)button {
    // 开关麦克风
    float level = [self.avSession getMicrophoneLevel];
    NSLog(@"麦克风等级: %f", level);
    if (level != 0) {
        [self.avSession adjustMicrophoneLevel:0];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute_hover"] forState:UIControlStateNormal];
    } else {
        [self.avSession adjustMicrophoneLevel:3];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];

    }
    // 更新按钮状态
//    [self updateAudioButton];
}

// 根据系统麦克风状态更新按钮状态
//-(void)updateAudioButton {
//    if ([self.avSession getMicrophoneLevel] != 0) {
//        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
//    } else {
//        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute_hover"] forState:UIControlStateNormal];
//    }
//}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
    NSLog(@"Device is close to user");
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
    NSLog(@"Device is not close to user");
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


- (void)setAvSession:(SipSession *)avSession {
    _avSession = avSession;
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
