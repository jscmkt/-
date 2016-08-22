//
//  CommentCell.m
//  新闻
//
//  Created by spare on 16/7/27.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    self.commentView = [[CommentView alloc]initWithFrame:CGRectZero];
    self.headIV.layer.cornerRadius = self.headIV.size.width/2;
    self.headIV.layer.masksToBounds = YES;
    
    [self addSubview:self.commentView];
}
-(void)setComment:(Comment *)comment{
    _comment = comment;
    BmobUser *user = [comment.bObj objectForKey:@"user"];
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]]];
    self.nameLabel.text = [user objectForKey:@"nick"];
    self.timeLabel.text = comment.createTime;
    self.commentView.comment = comment;
    self.commentView.frame = CGRectMake(0, 50, SCREEN_WIDTH, [comment getHeigth]);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.height = [self.comment getHeigth]+50;
}
@end
