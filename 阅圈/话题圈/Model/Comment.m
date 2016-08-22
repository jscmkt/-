//
//  Comment.m
//  新闻
//
//  Created by spare on 16/7/27.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "Comment.h"
#import "FaceUtils.h"
#import <YYTextView.h>
static YYTextView *_commentTextView;
@implementation Comment
-(instancetype)init{
    self = [super init];
    if (self) {
        self.imagePaths = [NSMutableArray array];
    }
    return self;
}
-(Comment *)initWithBmobObject:(BmobObject *)bObj{
    self = [super init];
    if (self) {
        self.text = [bObj objectForKey:@"text"];
        self.imagePaths = [bObj objectForKey:@"imagePaths"];
        self.bObj = bObj;
    }
    return self;
}
+(NSArray *)commentArrayFromBmobObjectArray:(NSArray *)array{
    NSMutableArray *hObjArray = [NSMutableArray array];
    for (BmobObject *bObj in array) {
        Comment *hObj = [[Comment alloc]initWithBmobObject:bObj];
        [hObjArray addObject:hObj];
        NSLog(@"%ld",hObjArray.count);
    }
    return hObjArray;
}
-(NSString *)createTime{
    NSDate *createDate = self.bObj.createdAt;
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
    
    //详情高度
    height += [self getTextHeight];
    if (self.imagePaths.count>0) {
        height += [self getImageHeight]+Margin;
    }
    return height;
}
-(float)getTextHeight{
    if (self.text.length == 0) {
        return 0;
    }
    if (!_commentTextView) {
        _commentTextView = [[YYTextView alloc]initWithFrame:CGRectMake(Margin, 0, SCREEN_WIDTH-Margin*2, 0)];
        _commentTextView.font = [UIFont systemFontOfSize:12];
        [FaceUtils faceBindingWithTextView:_commentTextView];
        
    }
    _commentTextView.text = self.text;
    return _commentTextView.textLayout.textBoundingSize.height;
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
@end
