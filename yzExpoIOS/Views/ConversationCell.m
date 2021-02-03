//
//  ConversationCell.m
//  ImoocHybridIOSNative
//
//  Created by 王思远 on 2020/12/26.
//  Copyright © 2020 LGD_Sunday. All rights reserved.
//

#import "ConversationCell.h"

@interface ConversationCell(UITableViewCell)

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation ConversationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TableViewCell";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    return cell;
}
@end
