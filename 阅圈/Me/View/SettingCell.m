//
//  SettingCell.m
//  新闻
//
//  Created by spare on 16/7/18.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

+(instancetype)cellWithTableView:(UITableView *)tableview{
    static NSString *ID = @"setting";
    SettingCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:237/255.0 green:233/255.0 blue:218/255.0 alpha:1];
        self.selectedBackgroundView = view;
    }
    return self;
}
-(void)setItem:(SettingItem *)item{
    _item = item;
    [self setUpCell];
}
-(void)setUpCell{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
    self.detailTextLabel.text = self.item.subtitle;
    self.detailTextLabel.textColor = [UIColor colorWithRed:65/255.0 green:173/255.0 blue:57/255.0 alpha:0.8];
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}
@end
