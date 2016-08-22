//
//  DetailImageWebModel.h
//  新闻
//
//  Created by spare on 16/7/19.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailImageWebModel : NSObject
@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

+ (instancetype)detailImgWithDict:(NSDictionary *)dict;

@end
