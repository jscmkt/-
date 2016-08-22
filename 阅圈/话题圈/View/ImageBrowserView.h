//
//  ImageBrowserView.h
//  新闻
//
//  Created by spare on 16/7/25.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeObj.h"
#import "Comment.h"
@interface ImageBrowserView : UIView
@property(nonatomic,strong)HomeObj *homeObj;
@property (nonatomic, strong)Comment *comment;
@end
