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

@interface AudioCallViewController ()

@property (strong, nonatomic) SipSession *avSession;

@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *telNumberLbl;
@property (weak, nonatomic) IBOutlet UIButton *acceptCallBtn;


@end

@implementation AudioCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 获取当前呼叫的session
    if (!self.avSession) {
        self.avSession = [self.getSipContext getCurrentSession];
    }
    if (self.avSession) {
        // 通过判断是呼入还是呼出，改变顶部状态文本的文字显示
        self.stateLbl.text = [self.avSession isOutgoing] ? @"去电":@"来电";
        // 获取当前呼叫的对端号码
        self.telNumberLbl.text = [self.avSession getRemotePartyDisplayName];
        // 通过判断是呼入还是呼出隐藏接听按钮
        self.acceptCallBtn.hidden = [self.avSession isOutgoing];
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

    if (event.eventType == CONNECTED) {
        // 建立通话时更改状态文本并隐藏接听按钮
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.stateLbl.text = @"通话中";
            self.acceptCallBtn.hidden = YES;
        });
    } else if (event.eventType == TERMINATED) {
        // 通话结束后关闭当前页面，并清空session
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.avSession = nil;
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
