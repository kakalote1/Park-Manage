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

@interface AudioCallViewController ()

@property (strong, nonatomic) SipSession *avSession;

@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *telNumberLbl;
@property (weak, nonatomic) IBOutlet UIButton *acceptCallBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangupCallBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLblLeading;

@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UILabel *hangupLbl;
@property (nonatomic, strong) UILabel *acceptLbl;
@property (nonatomic, strong) UILabel *speakerLbl;
@property (nonatomic, strong) UILabel *audioLbl;
@property (nonatomic, strong) UIImageView *portraitView;



@end

@implementation AudioCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _portraitView = [[UIImageView alloc] init];
    [self.portraitView setImage:[UIImage imageNamed:@"PersonalChat"]];
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.layer.cornerRadius = 10.0f;
    self.portraitView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.portraitView.layer.borderWidth = 1.0;
    self.portraitView.frame = CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.height / 4, self.view.frame.size.width / 3, self.view.frame.size.width / 3);
    [self.view addSubview:self.portraitView];
    
    self.stateLblLeading.constant = self.portraitView.frame.origin.y + self.portraitView.frame.size.height + 20;
    
    // 获取当前呼叫的session
    if (!self.avSession) {
        self.avSession = [self.getSipContext getCurrentSession];
    }
    if (self.avSession) {
        if ([self.avSession isOutgoing]) {
            // 通过判断是呼入还是呼出，改变顶部状态文本的文字显示
            self.stateLbl.text = @"去电";
            // 通过判断是呼入还是呼出隐藏接听按钮
            self.acceptCallBtn.hidden = YES;
            // 将挂断按钮居中
            self.buttonLeading.constant = self.view.frame.size.width/2-80/2;
        } else {
            self.acceptLbl.hidden = NO;
        }
        self.hangupLbl.hidden = NO;
        // 获取当前呼叫的对端号码
        self.telNumberLbl.text = [self.avSession getRemotePartyDisplayName];
    }
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

// 视图被销毁后清空sipSession
- (void)dealloc {
    self.avSession = nil;
}

- (IBAction)onClickAcceptCall:(UIButton *)sender {
    // 向服务器发送应答请求
    [[self.getSipContext getCurrentSession] acceptCall];

}

- (IBAction)onClickHangup:(UIButton *)sender {
    // 向服务器发送通话结束请求
    [[self.getSipContext getCurrentSession] hangupCall:@"AudioCall click hangup"];
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
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"已接通" duration:1.0 position:CSToastPositionDown];
            self.stateLbl.text = @"通话中";
            self.acceptCallBtn.hidden = YES;
            self.acceptLbl.hidden = YES;
            self.speakerButton.hidden = NO;
            self.speakerLbl.hidden = NO;
            self.audioButton.hidden = NO;
            self.audioLbl.hidden = NO;
            // 将挂断按钮居中
            self.buttonLeading.constant = self.view.frame.size.width/2-80/2;
    
            self.hangupLbl.frame = CGRectMake(self.view.frame.size.width/2-80/2, self.hangupCallBtn.frame.origin.y + 77, 72, 20);
        });
    } else if (event.eventType == TERMINATED) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"已挂断" duration:1.0 position:CSToastPositionDown];
        });

        // 通话结束后关闭当前页面，并清空session
        dispatch_after(dispatch_time(0ull, (int64_t) (2 * 1000000000ull)),dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.avSession = nil;
        
    }
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

// 设置挂断label属性
- (UILabel *)hangupLbl {
    if (!_hangupLbl) {
        _hangupLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.buttonLeading.constant, self.hangupCallBtn.frame.origin.y + 77, 72, 20)];
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
    
    // 更新按钮状态
    [self updateSpeakerButton];
}

// 根据系统扬声器状态更新按钮状态
-(void)updateSpeakerButton {
    
}

// 麦克风静音按钮点击事件
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
