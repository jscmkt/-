//
//  HeaderView.m
//  新闻
//
//  Created by spare on 16/7/20.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "HeaderView.h"
#import "RNBlurModalView.h"
@implementation HeaderView

-(void)awakeFromNib{
    self.headerImageView.layer.cornerRadius = self.nameBtn.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = self.nameBtn.layer.masksToBounds = YES;
//        self.headerImageView.image = [UIImage imageNamed:@"head"];
    self.topView.height = self.topView.superview.height/2;
    self.bottomView.height = self.bottomView.superview.height/2;
    self.topView.width = self.bottomView.width = SCREEN_WIDTH;
    self.bottomView.backgroundColor = [UIColor clearColor];
//    if ([BmobUser getCurrentUser]) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goinHead)];
//        self.headerImageView.userInteractionEnabled = YES;
//        [self.headerImageView addGestureRecognizer:tap];
//    }
}


-(void)setUser:(BmobUser *)user{
    _user = user;
    NSString *headPath = [user objectForKey:@"headPath"];
    NSString *nick = [user objectForKey:@"nick"];
    
    [self.nameBtn setTitle:nick forState:(UIControlStateNormal)];
    
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headPath]];
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:headPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.coverIV.image = [image boxblurImageWithBlur:.5];
        }];
    
        
    
    
}


@end
