//
//  HomeObjectView.m
//  新闻
//
//  Created by spare on 16/7/25.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "HomeObjectView.h"
#import "FaceUtils.h"
@implementation HomeObjectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[YYTextView alloc]initWithFrame:CGRectMake(Margin, 0, SCREEN_WIDTH-2*Margin, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [FaceUtils faceBindingWithTextView:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.detailTV = [[YYTextView alloc]initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.titleLabel.frame), SCREEN_WIDTH-2*Margin, 0)];
        [FaceUtils faceBindingWithTextView:self.detailTV];
        self.detailTV.font = [UIFont systemFontOfSize:15];
        self.detailTV.textColor = [UIColor grayColor];
        [self addSubview:self.detailTV];
        
        self.imageView = [[ImageBrowserView alloc]initWithFrame:CGRectZero];
        
        [self addSubview:self.imageView];
        //禁止交互
        self.titleLabel.userInteractionEnabled = self.detailTV.userInteractionEnabled = NO;
    }
    return self;
}


-(void)setHObj:(HomeObj *)hObj{
    
    _hObj = hObj;
    
    self.titleLabel.text = hObj.title;
    if (hObj.title.length==0) {
        self.titleLabel.height = 0;
    }else{
        self.titleLabel.height = 30;
    }
    
    self.detailTV.top = CGRectGetMaxY(self.titleLabel.frame)+Margin;
    self.detailTV.text = hObj.detail;
    self.detailTV.height = [hObj getDetailHeight];
    
    
    self.imageView.homeObj = hObj;
    self.imageView.frame = CGRectMake(Margin, CGRectGetMaxY(self.detailTV.frame)+Margin, SCREEN_WIDTH-2*Margin, [hObj getImageHeight]);
    
    
    
    
    
}

@end
