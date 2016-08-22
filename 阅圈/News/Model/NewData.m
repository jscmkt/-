//
//  NewData.m
//  新闻
//
//  Created by spare on 16/7/11.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "NewData.h"
#import "NSDate+gyh.h"
@implementation NewData
-(NSString *)ctime{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *createdDate = [fmt dateFromString:_ctime];
    if (createdDate.isToday) {
        if (createdDate.dateWithNow.hour>=1) {
            return [NSString stringWithFormat:@"%ld小时前",createdDate.dateWithNow.hour];
        }else if(createdDate.dateWithNow.minute>=1){
            return [NSString stringWithFormat:@"%ld分钟之前",createdDate.dateWithNow.minute];
        }else {
            return @"刚刚";
        }
    }else if(createdDate.isYesterday){
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
        
    }else if (createdDate.isThisYear){
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }else{
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}
@end
