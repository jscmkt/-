//
//  NewDataFrame.m
//  新闻
//
//  Created by spare on 16/7/13.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "NewDataFrame.h"

@implementation NewDataFrame
-(void)setNewData:(NewData *)NewData{
    _NewData = NewData;
    
    //图片
    CGFloat picurlX = 5;
    CGFloat picurlY = 10;
    CGFloat picurlW = 100;
    CGFloat picurlH = 70;
    _picUrlF = CGRectMake(picurlX, picurlY, picurlW, picurlH);
    
    //title
    CGFloat titleX = CGRectGetMaxX(_picUrlF) + 10;
    CGFloat titleY = picurlY;
    CGFloat titleW = SCREEN_WIDTH - 5 - titleX;
    CGFloat titleH = 45;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    _cellH = CGRectGetMaxY(_picUrlF) + 10;
}
@end
