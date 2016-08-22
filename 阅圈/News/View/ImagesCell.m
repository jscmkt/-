//
//  ImagesCell.m
//  新闻
//
//  Created by spare on 16/7/7.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "ImagesCell.h"
#import "UIImageView+WebCache.h"

@implementation ImagesCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"imagescell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ImagesCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        title.font = [UIFont systemFontOfSize:15];
        [self addSubview:title];
        self.titleL = title;
        CGFloat imageY = CGRectGetMaxY(title.frame)+10;
        CGFloat imageW = (SCREEN_WIDTH-40)/3;
        CGFloat imageH = 0.7*imageW;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,imageY, imageW, imageH)];
        imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:imageView];
        self.image1 = imageView;
        
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageY, imageW, imageH)];
        image2.backgroundColor = [UIColor grayColor];
        [self addSubview:image2];
        self.image2 = image2;
        
        UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame)+10, imageY, imageW, imageH)];
        image3.backgroundColor = [UIColor grayColor];
        [self addSubview:image3];
        self.image3 = image3;
        UILabel *replyL = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame), 100, 15)];
        replyL.textAlignment = NSTextAlignmentCenter;
        replyL.font = [UIFont systemFontOfSize:10];
        replyL.textColor = [UIColor darkGrayColor];
        [self addSubview:replyL];
        self.lblReply = replyL;
        
    }
    return self;
}
-(void)setDataModel:(DaataModel *)dataModel{
    _dataModel = dataModel;
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleL.text = self.dataModel.title;
    CGFloat count = [self.dataModel.replyCount intValue];
    NSString *displayCount;
    if (count>10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
//    self.lblReply.text = displayCount;
    self.lblReply.width = [self.lblReply.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width;
    
    [self.lblReply.layer setBorderWidth:1];
    [self.lblReply.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.lblReply.layer setCornerRadius:5];
    self.lblReply.clipsToBounds = YES;
    
    if (self.dataModel.imgextra.count == 2) {
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.imgextra[0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.imgextra[1][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }

    
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
