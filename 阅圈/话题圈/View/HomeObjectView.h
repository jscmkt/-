//
//  HomeObjectView.h
//  新闻
//
//  Created by spare on 16/7/25.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeObj.h"
#import <YYTextView.h>
#import "ImageBrowserView.h"
@interface HomeObjectView : UIView
@property(nonatomic,strong)HomeObj *hObj;

@property (nonatomic, strong)YYTextView *titleLabel;
@property (nonatomic, strong)YYTextView *detailTV;
@property (nonatomic, strong)ImageBrowserView *imageView;
@end
