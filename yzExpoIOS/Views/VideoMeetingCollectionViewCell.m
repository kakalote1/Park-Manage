//
//  VideoMeetingCollectionViewCell.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/10.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "VideoMeetingCollectionViewCell.h"
#import "MeetingMember.h"

@interface VideoMeetingCollectionViewCell ()
@property (strong, nonatomic) UILabel *numberLbl;
@property (strong, nonatomic) UIButton *muteBtn;
@property (strong, nonatomic) UIButton *recallBtn;
@property (strong, nonatomic) UIButton *videoBtn;

@end

@implementation VideoMeetingCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor: [UIColor colorWithWhite:0.2 alpha:0.3]];
        self.layer.cornerRadius = 20;
        [self createSubViews];
        
    }

    return self;
}

//每一组的偏移量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 50, 0, 0);
}

- (void) createSubViews {
    self.numberLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 20)];
    self.numberLbl.textAlignment = NSTextAlignmentCenter;
    self.numberLbl.textColor = [UIColor whiteColor];
    self.numberLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.numberLbl];
    self.muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 6, 30, self.frame.size.width / 6, self.frame.size.width / 4)];
    [self.muteBtn setBackgroundImage:[UIImage imageNamed:@"muteGroup"] forState:UIControlStateNormal];
    [self.muteBtn setBackgroundColor:[UIColor clearColor]];
    [self.muteBtn addTarget:self action:@selector(muteBtnDidTap:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.muteBtn];
    self.recallBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + self.frame.size.width / 8 , 30, self.frame.size.width / 4, self.frame.size.width / 4)];
    [self.recallBtn setBackgroundImage:[UIImage imageNamed:@"recall"] forState:UIControlStateNormal];
    [self.recallBtn setBackgroundColor:[UIColor clearColor]];
    [self.recallBtn addTarget:self action:@selector(recallBtnDidTap:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:self.recallBtn];
    self.videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.muteBtn.frame.origin.y + 30, self.frame.size.width, 30)];
    [self.videoBtn setTitle:@"查看视频" forState:UIControlStateNormal];
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.videoBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.videoBtn addTarget:self action:@selector(videoBtnDidTap:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.videoBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setMember:(MeetingMember *)member {
    _member = member;
    NSLog(@"member.name: %@", member.name);
    self.numberLbl.text = member.name;
}



- (UILabel *)numberLbl {
    if (_numberLbl) {
        _numberLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 20)];
        _numberLbl.textAlignment = NSTextAlignmentCenter;
        _numberLbl.textColor = [UIColor whiteColor];
        _numberLbl.font = [UIFont systemFontOfSize:15];

        [[self contentView] addSubview:_numberLbl];
    }
    return _numberLbl;
}

- (void)muteBtnDidTap: (UIButton *) button {
    if (self.delegate) {
        if (self.member.audience == FALSE) {
            [self.muteBtn setBackgroundImage:[UIImage imageNamed:@"mutemeeting_hover"] forState:UIControlStateNormal];
        NSLog(@"member tel : %@", self.member);
    [self.delegate member:self.member.tel audience:self.member.audience];
            
        } else {
            [self.muteBtn setBackgroundImage:[UIImage imageNamed:@"muteGroup"] forState:UIControlStateNormal];
            [self.delegate member:self.member.tel audience:self.member.audience];

        }

    }
}

- (void)recallBtnDidTap: (UIButton *) button {
    if (self.delegate) {
    [self.delegate recall:self.member.tel state:self.member.state];
    }
}

- (void)videoBtnDidTap: (UIButton *) button {
    if (self.delegate) {
        [self.delegate member:self.member.tel lookVideo:self.member.lookVideo];
    }
}

@end
