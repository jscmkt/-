//
//  HomeCell.m
//  新闻
//
//  Created by spare on 16/7/25.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "HomeCell.h"
#import "HomeObjectView.h"
@implementation HomeCell

//初始化方法
-(void)awakeFromNib{
    //设置Cell选中背景颜色
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.selectedBackgroundView.backgroundColor = GrayColor;
    //设置按钮的显示效果
    self.LikeBtn.layer.borderWidth = self.CommentBtn.layer.borderWidth = .5;
    self.LikeBtn.layer.cornerRadius = self.CommentBtn.layer.cornerRadius = 3;
    self.LikeBtn.layer.masksToBounds =  self.CommentBtn.layer.masksToBounds = YES;
    self.LikeBtn.layer.borderColor =  self.CommentBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.headIV.layer.cornerRadius = self.headIV.size.width/2;
    self.headIV.layer.masksToBounds =YES;
    self.hObjView = [HomeObjectView new];
    [self addSubview:self.hObjView];
}
-(void)setHObj:(HomeObj *)hObj{
    _hObj = hObj;
    //设置浏览量
    [self.LikeBtn setTitle:hObj.showCount.stringValue forState:(UIControlStateNormal)];
    //设置评论量
    [self.CommentBtn setTitle:hObj.commentCount.stringValue forState:(UIControlStateNormal)];
    
    //设置头像图片
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[hObj.user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    //显示名字
    self.nameLabel.text = [hObj.user objectForKey:@"nick"];
    //显示时间
    self.timeLable.text = [hObj createTime];
    
    //显示具体内容
    self.hObjView.frame = CGRectMake(0, 60, SCREEN_WIDTH, [hObj getHeigth]);
    
    
    self.hObjView.hObj = hObj;
}
@end
