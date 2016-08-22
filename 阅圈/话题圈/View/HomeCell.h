//
//  HomeCell.h
//  新闻
//
//  Created by spare on 16/7/25.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeObjectView.h"
#import "HomeObj.h"
@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *CommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *LikeBtn;

@property(nonatomic,strong) HomeObj *hObj;
@property(nonatomic,strong) HomeObjectView *hObjView;
@end
