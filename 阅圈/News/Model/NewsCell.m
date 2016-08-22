//
//  NewsCell.m
//  新闻
//
//  Created by spare on 16/7/6.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
@implementation NewsCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"newscell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageV = [UIImageView new];
        imageV.frame = CGRectMake(10, 10, 80, 60);
        [self addSubview:imageV];
        self.imgIcon = imageV;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetMaxX(imageV.frame)+10), 10, SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 40)];
        label.numberOfLines = 0;
        if (SCREEN_WIDTH == 320) {
            label.font = [UIFont systemFontOfSize:14];
            
        }else{
        label.font = [UIFont systemFontOfSize:16];
        }
        [self addSubview:label];
        self.lblTitle = label;
        UILabel *scrl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(label.frame), SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 40)];
        scrl.numberOfLines = 0;
        scrl.font = [UIFont systemFontOfSize:14];
        scrl.textColor = [UIColor lightGrayColor];
        [self addSubview:scrl];
        self.lblSubtitle = scrl;
        
        UILabel *replyl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-100, CGRectGetMaxY(imageV.frame)-10, 100, 15)];
        replyl.textAlignment = NSTextAlignmentCenter;
        replyl.font = [UIFont systemFontOfSize:10];
        replyl.textColor = [UIColor darkGrayColor];
        [self addSubview:replyl];
        self.lblReply = replyl;
        
        UILabel *resorcel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(imageV.frame)-10, 150, 20)];
        resorcel.font = [UIFont systemFontOfSize:10];
        resorcel.textColor = [UIColor darkGrayColor];
        [self addSubview:resorcel];
        self.resorceL = resorcel;
        
    }
    return self;
}
-(void)setDataModel:(DaataModel *)dataModel{
    _dataModel = dataModel;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.lblTitle.text = self.dataModel.title;
    self.resorceL.text = self.dataModel.source;
//    CGFloat count = [self.dataModel.replyCount intValue];
//    NSString *displayCount;
//    if (count > 10000) {
//        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
//        
//        
//    }else{
//        displayCount = [NSString stringWithFormat:@"%.0f",count];
//    
//    }
    NSString *ptime = self.dataModel.ptime;
    self.lblReply.text = ptime;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    self.lblReply.width = [self.lblReply.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size.width;
    self.lblReply.width += 10;
    self.lblReply.x = SCREEN_WIDTH-10-self.lblReply.width;
    self.lblReply.layer.cornerRadius = 5;
    self.lblReply.layer.borderWidth = 1;
    self.lblReply.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.lblReply.clipsToBounds = YES;
}
+ (NSString *)idForRow:(DaataModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID) {
        return @"TopCell";
    }else if (NewsModel.hasHead){
        return @"TopCell";
    }else if (NewsModel.imgType){
        return @"BigImageCell";
    }else if (NewsModel.imgextra){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}
+(CGFloat)heightForRow:(DaataModel *)NewsModel{
    if (NewsModel.imgType){
        return 0;
    }else if (NewsModel.hasHead && NewsModel.photosetID){
        return 0;
    }else if(NewsModel.hasHead) {
        return 0;
    }else if (NewsModel.imgextra) {
        return 150;
    }
    else{
        return 80;
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
