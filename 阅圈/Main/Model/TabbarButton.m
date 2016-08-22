//
//  TabbarButton.m
//  新闻
//
//  Created by spare on 16/6/20.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "TabbarButton.h"

@implementation TabbarButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor colorWithRed:219/255.0f green:86/255.0f blue:85/255.0f alpha:1] forState:(UIControlStateSelected)];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imagew = contentRect.size.width;
    CGFloat imageh = contentRect.size.height*0.6;
    return CGRectMake(0, 0, imagew, imageh);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY =contentRect.size.height*0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

-(void)setItem:(UITabBarItem *)item{
    _item = item;
    [self setTitle:item.title forState:(UIControlStateNormal)];
    [self setImage:item.image forState:(UIControlStateNormal)];
    [self setImage:item.selectedImage forState:(UIControlStateSelected)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
