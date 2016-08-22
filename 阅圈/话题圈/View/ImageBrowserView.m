//
//  ImageBrowserView.m
//  新闻
//
//  Created by spare on 16/7/25.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "ImageBrowserView.h"
#import "PhotoBroswerVC.h"
@implementation ImageBrowserView
-(void)setHomeObj:(HomeObj *)homeObj{
    _homeObj = homeObj;
    //清空自身显示的之前的图片
    for (UIImageView *iv in self.subviews) {
        [iv removeFromSuperview];
    }
    if (homeObj.imagePaths.count==1 ) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*Margin, ImageSize)];
        NSString *path = homeObj.imagePaths[0];
        
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [iv sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        iv.clipsToBounds = YES;
        iv.tag = 0;
        [self addSubview:iv];
        //给图片添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [iv addGestureRecognizer:tap];
        iv.userInteractionEnabled = YES;
    }else{
        for (int i=0 ; i<homeObj.imagePaths.count; i++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i%3*(ImageSize+Margin), i/3*(ImageSize+Margin), ImageSize, ImageSize)];
            NSString *path = homeObj.imagePaths[i];
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
            [iv sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
            iv.tag = i;
            [self addSubview:iv];
            //给图片添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [iv addGestureRecognizer:tap];
            iv.userInteractionEnabled = YES;
            
            
        }
    }
}

-(void)setComment:(Comment *)comment{
    _comment = comment;
    
    
    //清空自身显示的之前的图片
    for (UIImageView *iv in self.subviews) {
        [iv removeFromSuperview];
    }
    
    
    if (comment.imagePaths.count==1) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*Margin, 2*ImageSize)];
        NSString *path = comment.imagePaths[0];
        
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [iv sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        iv.clipsToBounds = YES;
        iv.tag = 0;
        [self addSubview:iv];
        //给图片添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [iv addGestureRecognizer:tap];
        iv.userInteractionEnabled = YES;
        
    }else{
        
        for (int i=0; i<comment.imagePaths.count; i++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i%3*(ImageSize+Margin), i/3*(ImageSize+Margin), ImageSize, ImageSize)];
            NSString *path = comment.imagePaths[i];
            
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
            [iv sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
            
            iv.tag = i;
            [self addSubview:iv];
            //给图片添加点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [iv addGestureRecognizer:tap];
            iv.userInteractionEnabled = YES;
            
        }
        
        
        
        
    }

}








-(void)tapAction:(UITapGestureRecognizer*)tap{
    UIImageView *iv = (UIImageView*)tap.view;
    //[UIApplication sharedApplication].keyWindow.rootViewController 得到的是当前程序window的根页面
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:(PhotoBroswerVCTypeZoom) index:iv.tag photoModelBlock:^NSArray *{
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.homeObj.imagePaths.count];
        for (NSUInteger i=0; i<self.homeObj.imagePaths.count; i++) {
            PhotoModel *pbModel = [[PhotoModel alloc]init];
            pbModel.mid = i+1;
            NSString *path = self.homeObj.imagePaths[i];
            
            //设置查看大图的图片地址
            pbModel.image_HD_U = path;
            //源图片的frame
            UIImageView *imageV = (UIImageView*)self.subviews[i];
            pbModel.sourceImageView = imageV;
            [modelsM addObject:pbModel];
            
        }
        return modelsM;
    }];
}

@end
