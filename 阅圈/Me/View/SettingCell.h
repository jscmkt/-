//
//  SettingCell.h
//  新闻
//
//  Created by spare on 16/7/18.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingItem.h"
@interface SettingCell : UITableViewCell
@property(nonatomic,strong)SettingItem *item;
+(instancetype)cellWithTableView:(UITableView *)tableview;
@end
