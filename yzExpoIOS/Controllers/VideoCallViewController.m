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

@interface VideoCallViewController ()

@property (strong, nonatomic) SipSession *avSession;

@property (nonatomic, strong) UIView *bigVideoView;
@property (nonatomic, strong) UIView *smallVideoView;
@property (nonatomic, strong) UILabel *stateLbl;
@property (nonatomic, strong) UILabel *telNumberLbl;
@property (nonatomic, strong) UIButton *acceptCallBtn;
@property (nonatomic, strong) UIButton *hangupCallBtn;
@property (nonatomic, strong) UIButton *switchCameraButton;

@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UILabel *hangupLbl;
@property (nonatomic, strong) UILabel *acceptLbl;
@property (nonatomic, strong) UILabel *speakerLbl;
@property (nonatomic, strong) UILabel *audioLbl;
@end

@implementation VideoCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.bigVideoView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.hangupCallBtn.hidden = NO;
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

- (void)handleInviteEvent:(NSNotification *)notification {
    SipInviteEvent *event = [notification object];
    
    // 如果当前回话的sessonId与通知中的sessionId不同直接返回
    if ([self.avSession getId] != event.sessionId) {
        return;
    }

    if (event.eventType == CONNECTED) {
        // 建立通话时更改状态文本并隐藏接听按钮
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.stateLbl.text = @"通话中";
            self.acceptCallBtn.hidden = YES;
            self.acceptLbl.hidden = YES;
            self.speakerButton.hidden = NO;
            self.speakerLbl.hidden = NO;
            self.audioButton.hidden = NO;
            self.audioLbl.hidden = NO;
            // 将挂断按钮居中

    
            self.hangupLbl.frame = CGRectMake(self.view.frame.size.width/2-80/2, self.hangupCallBtn.frame.origin.y + 77, 72, 20);
        });
    } else if (event.eventType == TERMINATED) {
        // 通话结束后关闭当前页面，并清空session
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.avSession = nil;
        
    }
}

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

- (void)setAvSession:(SipSession *)avSession {
    _avSession = avSession;
}

- (void)hangupButtonDidTap:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
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
