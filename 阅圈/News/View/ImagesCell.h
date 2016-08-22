//
//  ImagesCell.h
//  新闻
//
//  Created by spare on 16/7/7.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DaataModel.h"
@interface ImagesCell : UITableViewCell
@property (nonatomic , strong) DaataModel *dataModel;

/**
 *  标题
 */
@property (nonatomic , weak) UILabel *titleL;
/**
 *  跟帖数
 */
@property (nonatomic , weak) UILabel *lblReply;

/**
 *  多图
 */
@property (nonatomic , weak) UIImageView *image1;
@property (nonatomic , weak) UIImageView *image2;
@property (nonatomic , weak) UIImageView *image3;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
