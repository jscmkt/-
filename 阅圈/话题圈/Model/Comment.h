//
//  Comment.h
//  新闻
//
//  Created by spare on 16/7/27.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeObj.h"
typedef void (^MyCallBack)(id obj);
@interface Comment : NSObject
@property(nonatomic,copy)NSString *text;
@property(nonatomic,strong)HomeObj *hObj;
@property(nonatomic,strong)BmobObject *bObj;
@property(nonatomic,strong)NSMutableArray *imagePaths;
-(Comment*)initWithBmobObject:(BmobObject*)bObj;

//传递进来一个bmob对象数组 返回hObj数组
+(NSArray *)commentArrayFromBmobObjectArray:(NSArray *)array;


-(NSString *)createTime;
-(float)getTextHeight;
-(float)getImageHeight;
-(float)getHeigth;
@end
