//
//  CommentView.h
//  新闻
//
//  Created by spare on 16/7/28.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageBrowserView.h"
#import <YYTextView.h>
#import "Comment.h"
@interface CommentView : UIView
@property (nonatomic, strong)YYTextView *textView;
@property (nonatomic, strong)ImageBrowserView *imageView;
@property (nonatomic, strong)Comment *comment;
@end
