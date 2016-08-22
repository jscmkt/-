//
//  HeaderView.h
//  新闻
//
//  Created by spare on 16/7/20.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;

@property (nonatomic,strong) BmobUser *user;


@end
