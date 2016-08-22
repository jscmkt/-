//
//  UserTool.m
//  新闻
//
//  Created by spare on 16/7/22.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "UserTool.h"

@implementation UserTool
static UserTool *_userTool;
+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userTool = [super allocWithZone:zone];
    });
    return _userTool;
}
+(instancetype)shareUserTool{
    if (_userTool == nil) {
        _userTool = [[UserTool alloc]init];
    }
    return _userTool;
}
@end
