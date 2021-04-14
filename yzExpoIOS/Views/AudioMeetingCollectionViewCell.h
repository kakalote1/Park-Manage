//
//  AudioMeetingCollectionViewCell.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/9.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ScPoc/SipMeetingMessage.h>

@class MeetingMember;

NS_ASSUME_NONNULL_BEGIN

@protocol AudioMeetingCollectionViewCellDelegate <NSObject>

- (void)member:(NSString *)tel audience:(BOOL)audience;

- (void)member:(NSString *)tel along:(BOOL)along;

- (void)recall:(NSString *)tel state:(SipMeetingMessageState)state;

- (void)hangup:(NSString *)tel state:(SipMeetingMessageState)state;

@end


@interface AudioMeetingCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) MeetingMember *member;
@property (nonatomic) BOOL host;
@property (weak, nonatomic) id<AudioMeetingCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
