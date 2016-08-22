//
//  DetailWebModel.h
//  新闻
//
//  Created by spare on 16/7/19.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailWebModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 内容 */
@property (nonatomic, copy) NSString *body;
/** 配图 */
@property (nonatomic, strong) NSArray *img;
/** 版本不够跳转的url */
@property (nonatomic,copy )NSString *href;
/** 版本不够标题 */
@property(nonatomic,copy)NSString *linkTitle;
+ (instancetype)detailWithDict:(NSDictionary *)dict;
@end
