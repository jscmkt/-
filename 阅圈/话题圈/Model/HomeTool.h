//
//  HomeTool.h
//  新闻
//
//  Created by spare on 16/7/24.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTool : NSObject
@property(nonatomic,strong) NSNumber *showCount;
@property(nonatomic,strong) NSNumber *commentCount;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,strong)NSArray *imagePaths;

@property(nonatomic,strong)BmobUser *user;



@end
