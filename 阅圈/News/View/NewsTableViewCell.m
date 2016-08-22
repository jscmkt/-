//
//  NewsTableViewCell.m
//  新闻
//
//  Created by spare on 16/7/14.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation NewsTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:imageV];
        self.imageV = imageV;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        self.backgroundColor = [UIColor clearColor];
        

    }
    return self;
}

-(void)setDataFrame:(NewDataFrame *)dataFrame{
    _dataFrame = dataFrame;
    NewData *data = _dataFrame.NewData;
    
    //图片
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:data.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.imageV.frame = _dataFrame.picUrlF;
    
    //title
    self.titleLabel.text = data.title;
    self.titleLabel.frame = _dataFrame.titleF;
    //时间
    self.timeLabel.text = data.ctime;
    
    CGSize textMaxSize= CGSizeMake(200, MAXFLOAT);
    CGSize textRealSzie = [self.timeLabel.text boundingRectWithSize:textMaxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    CGFloat ctimeX = SCREEN_WIDTH - textRealSzie.width-10;
    CGFloat ctimeY = CGRectGetMaxY(_dataFrame.titleF) + 10;
    self.timeLabel.frame = (CGRect){{ctimeX,ctimeY},textRealSzie};
}



#pragma mark 重画tableView的线
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width-10, 1));
}


@end
