//
//  SettingItem.h
//  新闻
//
//  Created by spare on 16/7/18.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SetttingItemOption)();
@interface SettingItem : NSObject
/** 图标 */
@property (nonatomic,copy) NSString *icon;
/** 标题 */
@property(nonatomic,copy)NSString *title;
/** 副标题 */
@property(nonatomic,copy) NSString *subtitle;
//操作
@property(nonatomic,copy)SetttingItemOption option;
+ (instancetype)itemWithItem:(NSString *)icon title:(NSString *)title;

+ (instancetype)itemWithItem:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle;
@end
