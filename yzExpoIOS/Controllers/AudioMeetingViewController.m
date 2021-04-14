//
//  AudioMeetingViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/6.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <ScPoc/MeetingManager.h>
#import <ScPoc/NSString+SipUtils.h>
#import <ScPoc/SipSettings.h>
#import "AudioMeetingViewController.h"
#import "MeetingMember.h"
#import "AudioMeetingCollectionViewCell.h"
#import "MeetingModel.h"
#import <ScPoc/SipSession.h>

@interface AudioMeetingViewController () <MeetingEventDelegate,AudioMeetingCollectionViewCellDelegate,UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *memberListView;
@property (strong, nonatomic) UIButton *hangupCallBtn;
@property (strong, nonatomic) UIButton *acceptCallBtn;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UILabel *hangupLbl;
@property (nonatomic, strong) UILabel *acceptLbl;
@property (nonatomic, strong) UILabel *speakerLbl;
@property (nonatomic, strong) UILabel *audioLbl;
@property (strong, nonatomic) UILabel *stateLbl;


@property (nonatomic, strong) UIView *viewCell;
@property (nonatomic, strong) UILabel *telName;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *callBtn;

@property (nonatomic, strong) AVAudioSession *avAudioSession;

@property (weak, nonatomic) MeetingManager *manager;
@property (weak, nonatomic) SipSession *sipSession;

@property (strong, nonatomic) NSMutableArray<MeetingMember *> *members;
@property (strong, nonatomic) NSMutableDictionary<NSString *, MeetingMember *> *memberMap;
@property (strong, nonatomic) NSString *hostTel;



@end

@implementation AudioMeetingViewController

- (NSMutableArray *)members {
    if (!_members) {
        _members = [[NSMutableArray alloc] initWithCapacity:16];
    }
    return _members;
}

- (NSMutableDictionary<NSString *, MeetingMember *> *)memberMap {
    if (!_memberMap) {
        _memberMap = [[NSMutableDictionary alloc] initWithCapacity:16];
    }
    return _memberMap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avAudioSession = [AVAudioSession sharedInstance];



    
    UIImage *img = [UIImage imageNamed:@"background"];
    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(self.view.frame.size.width, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    UIImage *newImg = [img resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    self.view.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.hangupCallBtn.hidden = NO;
    self.hangupLbl.hidden = NO;
    // Do any additional setup after loading the view.
    self.manager = [self.getSipContext getMeetingManager];
    [self.manager registerReceiver:self];
    self.hostTel = [self.getSipContext getLoginUser];

    if ([self.getSipContext getCurrentSession]) {
        self.sipSession = [self.getSipContext getCurrentSession];
    }
    

//    AudioMeetingCollectionViewCell * audioCell = [[AudioMeetingCollectionViewCell alloc] initWithFrame: CGRectMake(100, 100, 100, 60)];
//    [self.view addSubview:audioCell];
//
    self.stateLbl.text = @"正在呼叫";
    self.stateLbl.hidden = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //行与行间的距离
     flowLayout.minimumLineSpacing = 10;
     //列与列间的距离
     flowLayout.minimumInteritemSpacing = 10;
     //设置item的大小
     flowLayout.itemSize = CGSizeMake(110, 80);
     flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.memberListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 500) collectionViewLayout:flowLayout];
    self.memberListView.dataSource = self;
    self.memberListView.delegate = self;
    self.memberListView.backgroundColor = [UIColor clearColor];
    [self.memberListView registerClass:[AudioMeetingCollectionViewCell class] forCellWithReuseIdentifier:@"AudioMeetingCollectionViewCell"];
    [self.view addSubview:self.memberListView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.manager unregisterReceiver:self];
}

- (void)dealloc {
    self.manager = nil;
    self.sipSession = nil;
}

#pragma mark - UICollectionViewDataSource
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    NSLog(@"self.members: %lu", (unsigned long)self.members.count);
//    return self.members.count;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"self.members.count ： %lu", (unsigned long)self.members.count);
    return self.members.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AudioMeetingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AudioMeetingCollectionViewCell" forIndexPath:indexPath];
    NSArray *subViews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    cell.delegate = self;
    MeetingMember *member = self.members[indexPath.row];
    cell.member = member;
    return cell;
}

// 设置接听按钮属性
- (UIButton *)hangupCallBtn {
    if (!_hangupCallBtn) {
        _hangupCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 36, self.view.frame.size.height - 60 - 72, 72, 72)];
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

- (UILabel *)stateLbl {
    if (!_stateLbl) {
        _stateLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height / 7, 100, 23)];
        _stateLbl.font = [UIFont systemFontOfSize:24];
        _stateLbl.textAlignment = NSTextAlignmentCenter;
        _stateLbl.textColor = [UIColor whiteColor];

        _stateLbl.hidden = YES;
        [self.view addSubview:_stateLbl];
    }
    return _stateLbl;
}

- (void)hangupButtonDidTap:(UIButton *)button {
    [self.manager hangupMeeting];
    dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
}

- (void)audioButtonDidTap:(UIButton *)button {
    // 开关麦克风
    float level = [self.sipSession getMicrophoneLevel];
    NSLog(@"麦克风等级: %f", level);
    if (level != 0) {
        [self.sipSession adjustMicrophoneLevel:0];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute_hover"] forState:UIControlStateNormal];
    } else {
        [self.sipSession adjustMicrophoneLevel:3];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    }
}

#pragma mark - MeetingEventListener
- (void)handleConnected:(SipSession *)sipSession {
    self.sipSession = sipSession;
    if (self.sipSession != nil) {
        [self.manager addMeetingMember:[self.getSipContext getLoginUser]];
        MeetingModel *model = [MeetingModel shareInstance];
        NSArray *dataList = model.dataList;
        NSLog(@"telList: %@", dataList);
        for (NSDictionary *dic in dataList) {
            NSString *tel = dic[@"tel"];
            NSString *name = dic[@"name"];
            if ([self.manager isInMeeting]) {
                [self.manager addMeetingMember:tel];
                            }
            MeetingMember *member = [[MeetingMember alloc] initWithTel:tel video:NO name:name];
            NSLog(@"member: %@", member);
            [self.members addObject:member];
            self.memberMap[tel] = member;
        }
     
//        for (NSString *number in telList) {
//            if (![NSString isEmpty:number]) {
//                if ([self.manager isInMeeting]) {
//                    [self.manager addMeetingMember:number];
//                }
//            }
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stateLbl.text = @"会议中";
            [self updateTableView];
        });
    }
}

- (void)handleAllAudience:(BOOL)isAllAudience members:(NSArray<NSString *> *)members {
    for (MeetingMember *member in self.members) {
        member.state = isAllAudience ? SipMeetingMsgStateAudience : SipMeetingMsgStateSpeaking;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    [self updateTableView];
    });
}

- (void)handleTerminated {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.stateLbl.text = @"会议结束";
        if ([[self.navigationController viewControllers] containsObject:self]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)handleJoin:(NSArray<NSString *> *)joinArray {
    MeetingModel *model = [MeetingModel shareInstance];
    joinArray = model.list;
    dispatch_async(dispatch_get_main_queue(), ^{

    [self updateTableView];
        });
}

- (void)handleLeave:(NSArray<NSString *> *)leaveArray {
//    for (NSString *tel in leaveArray) {
//        [self.members removeObject:self.memberMap[tel]];
//        [self.memberMap removeObjectForKey:tel];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
////    [self updateTableView];
//    });
}

- (void)handleSource:(NSString *)source {
    for (MeetingMember *member in self.members) {
        if (![member.tel isEqualToString:source] && member.follow) {
            [member cancelFollow];
        }
    }
    MeetingMember *member = self.memberMap[source];
    if (member) {
        member.state = SipMeetingMsgStateSendVideo;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

    [self updateTableView];
    });
}

- (void)handleLookVideoWithOld:(NSString *)oldLookTel current:(NSString *)currentLookTel {
    MeetingMember *member = self.memberMap[oldLookTel];
    if (member) {
        [member cancelLookVideo];
    }
    member = self.memberMap[currentLookTel];
    if (member) {
        member.state = SipMeetingMsgStateLookVideo;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

    [self updateTableView];
    });
}

- (void)handleMemberStateChange:(NSString *)memberTel isVideo:(BOOL)video volume:(NSUInteger)volLevel state:(SipMeetingMessageState)state {
    MeetingMember *member = self.memberMap[memberTel];
    if (member) {
        member.video = video;
        member.state = state;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

    [self updateTableView];
    });
    }

- (void)updateTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.memberListView reloadData];
    });
}

#pragma mark - AudioMeetingTableViewCellDelegate

- (void)member:(NSString *)tel audience:(BOOL)audience {
    [self.manager sendAudience:tel audience:audience];
}

- (void)member:(NSString *)tel along:(BOOL)along {
    [self.manager alongCall:tel along:along];
}

- (void)recall:(NSString *)tel state:(SipMeetingMessageState)state {
    [self.manager reCall:tel state:state];
}

- (void)hangup:(NSString *)tel state:(SipMeetingMessageState)state {
    [self.manager hangup:tel state:state];
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
