//
//  HomeObj.m
//  新闻
//
//  Created by spare on 16/7/24.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "HomeObj.h"
#import "MJExtension.h"
#import "NSDate+gyh.h"
#import <YYTextView.h>
#import "FaceUtils.h"
@implementation HomeObj
static YYTextView *_textView;
-(instancetype)initWith:(BmobObject *)bObj{
    self = [super init];
    if (self) {
        self.bobj = bObj;
        self.createAt = bObj.createdAt;
        /*@property(nonatomic,strong) NSNumber *showCount;
         @property(nonatomic,strong) NSNumber *commentCount;
         @property(nonatomic,copy)NSString *title;
         @property(nonatomic,copy)NSString *detail;
         @property(nonatomic,strong)NSArray *imagePaths;
         
         @property(nonatomic,strong)BmobUser *user;*/
        self.showCount = [bObj objectForKey:@"showCount"];
        self.commentCount = [bObj objectForKey:@"commentCount"];
        self.title = [bObj objectForKey:@"title"];
        self.detail = [bObj objectForKey:@"detail"];
        self.imagePaths = [bObj objectForKey:@"imagePaths"];
        self.user = [bObj objectForKey:@"user"];
//        self.homeTool = [HomeTool objectWithKeyValues:bObj.keyValues];
    }
    return self;
}

-(NSString *)createTime{
    NSDate *createDate = self.createAt;
    NSDate *nowDate = [NSDate date];
    long createTime = [createDate timeIntervalSince1970];
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime-createTime;
    if (time<60) {
        return @"刚刚";
    }else if (time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
        
    }else if(time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}
-(float)getHeigth{
    float height = Margin;
    //title高度
    if (self.title.length>0) {
        height+=30;
    }
    //详情高度
    height += [self getDetailHeight];
    if (self.imagePaths.count>0) {
        height += [self getImageHeight];
    }
    return height;
}
-(float)getDetailHeight{
    if (self.detail.length == 0) {
        return 0;
    }
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(Margin, 0, SCREEN_WIDTH-Margin*2, 0)];
        _textView.font = [UIFont systemFontOfSize:12];
        [FaceUtils faceBindingWithTextView:_textView];
        
    }
    _textView.text = self.detail;
    return _textView.textLayout.textBoundingSize.height;
}
-(float)getImageHeight{
    long count = self.imagePaths.count;
    if (count==1) {
        return ImageSize*2;
        
    }else if (count>1&&count<=3){
        return ImageSize;
    }else if (count>3&&count<=6){
        return ImageSize*2+Margin;
    }else if (count>6&&count<=9){
        return ImageSize*3+2*Margin;
    }
    return 0;
}
-(void)addShowCountWithCompletionBlock:(MyCallback)callback{
    [self.bobj incrementKey:@"showCount"];
    //更新数据时
    [self.bobj setObject:self.user forKey:@"user"];
    [self.bobj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"浏览量增加");
            
            self.showCount = @(self.showCount.intValue + 1);
            //让controller响应
            callback(self);
        }
    }];
}
-(void)addCommentCountWithCompletionBlock:(MyCallback)callback{
    //让comment的值递增1
    [self.bobj incrementKey:@"commentCount"];
    //更新数据时 对象类型的字段 需要重新赋值
    [self.bobj setObject:self.user forKey:@"user"];
    [self.bobj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"评论量增加");
            self.commentCount = @(self.commentCount.intValue+1);
            //让controller响应
            callback(self);
        }
    }];
}
@end
