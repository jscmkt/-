//
//  DetailWebModel.m
//  新闻
//
//  Created by spare on 16/7/19.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "DetailWebModel.h"
#import "DetailImageWebModel.h"
@implementation DetailWebModel
+(instancetype)detailWithDict:(NSDictionary *)dict{
    DetailWebModel *detail = [[self alloc] init];
    detail.title = dict[@"title"];
    detail.ptime = dict[@"ptime"];
    detail.body = dict[@"body"];
    if (((NSArray*)dict[@"link"]).count>1) {
        detail.linkTitle = dict[@"link"][0][@"title"];
        detail.href = dict[@"link"][0][@"href"];
    }
    
    NSArray *imgArray = dict[@"img"];
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:imgArray.count];
    for (NSDictionary *dict in imgArray) {
        DetailImageWebModel *imgModel = [DetailImageWebModel detailImgWithDict:dict];
        [temArray addObject:imgModel];
    }
    detail.img = temArray;
    return detail;
}
@end
