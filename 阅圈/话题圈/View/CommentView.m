//
//  CommentView.m
//  新闻
//
//  Created by spare on 16/7/28.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "CommentView.h"
#import "FaceUtils.h"
@implementation CommentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(Margin, 0, SCREEN_WIDTH-2*Margin, 0)];
        [FaceUtils faceBindingWithTextView:self.textView];
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.textColor = [UIColor blackColor];
        [self addSubview:self.textView];
        self.textView.userInteractionEnabled = NO;
        self.imageView = [[ImageBrowserView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.imageView];
    }
    return self;
    
}
-(void)setComment:(Comment *)comment{
    _comment = comment;
    self.textView.text = comment.text;
    self.textView.height = [comment getTextHeight];
    if (comment.imagePaths.count>0) {
        self.imageView.hidden = NO;
        self.imageView.comment = comment;
        self.imageView.frame = CGRectMake(Margin, CGRectGetMaxY(self.textView.frame)+Margin, SCREEN_WIDTH-2*Margin, [comment getImageHeight]);
    }else{
        self.imageView.hidden = YES;
    }
}

@end
