//
//  VideoMeetingCollectionViewCell.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/10.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioMeetingCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VideoMeetingCollectionViewCellDelegate <AudioMeetingCollectionViewCellDelegate>

- (void)member:(NSString *)tel follow:(BOOL)follow;
- (void)member:(NSString *)tel lookVideo:(BOOL)lookVideo;

@end

@interface VideoMeetingCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) MeetingMember *member;
@property (nonatomic) BOOL host;
@property (weak, nonatomic) id<VideoMeetingCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
