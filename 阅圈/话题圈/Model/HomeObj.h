//
//  HomeObj.h
//  新闻
//
//  Created by spare on 16/7/24.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTool.h"
typedef void (^MyCallback)(id obj);
@interface HomeObj : NSObject
@property(nonatomic,strong)BmobObject *bobj;
@property(nonatomic,strong)NSDate *createAt;
//@property (nonatomic,strong)HomeTool *homeTool;
@property(nonatomic,strong) NSNumber *showCount;
@property(nonatomic,strong) NSNumber *commentCount;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,strong)NSArray *imagePaths;

@property(nonatomic,strong)BmobUser *user;

-(instancetype)initWith:(BmobObject *)bObj;
-(NSString *)createTime;
-(float)getHeigth;
-(float)getImageHeight;
-(float)getDetailHeight;

-(void)addShowCountWithCompletionBlock:(MyCallback)callback;

-(void)addCommentCountWithCompletionBlock:(MyCallback)callback;
@end
