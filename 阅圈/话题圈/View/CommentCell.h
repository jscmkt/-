//
//  CommentCell.h
//  新闻
//
//  Created by spare on 16/7/27.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CommentView.h"
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)Comment *comment;
@property(nonatomic,strong)CommentView *commentView;
@end
