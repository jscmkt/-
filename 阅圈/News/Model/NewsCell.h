//
//  NewsCell.h
//  新闻
//
//  Created by spare on 16/7/6.
//  Copyright © 2016年 spare. All rights reserved.
//
#import "DaataModel.h"
#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property(nonatomic,strong) DaataModel *dataModel;

/**
 *  图片
 */
@property (strong, nonatomic) UIImageView *imgIcon;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *lblTitle;
/**
 *  回复数
 */
@property (strong, nonatomic) UILabel *lblReply;
/**
 *  描述
 */
@property (strong, nonatomic) UILabel *lblSubtitle;
/**
 *  第二张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgOther1;
/**
 *  第三张图片（如果有的话）
 */
@property (strong, nonatomic) UIImageView *imgOther2;
/**
 *  来源
 */
@property (nonatomic , strong) UILabel *resorceL;



/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(DaataModel *)NewsModel;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(DaataModel *)NewsModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
