//
//  NewsTableViewCell.h
//  新闻
//
//  Created by spare on 16/7/14.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDataFrame.h"
@interface NewsTableViewCell : UITableViewCell
@property(nonatomic,strong)NewDataFrame *dataFrame;
@property (nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
