//
//  SettingGroup.h
//  新闻
//
//  Created by spare on 16/7/18.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingGroup : NSObject

@property(nonatomic,copy)NSString *headtitle;
@property(nonatomic,copy)NSString *foottitle;
@property(nonatomic,strong)NSArray *items;
@end
