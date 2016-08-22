//
//  NewDataFrame.h
//  新闻
//
//  Created by spare on 16/7/13.
//  Copyright © 2016年 spare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewData.h"
@interface NewDataFrame : NSObject
@property (nonatomic , strong) NewData *NewData;

@property (nonatomic , assign) CGRect descriptionF;
@property (nonatomic , assign) CGRect picUrlF;
@property (nonatomic , assign) CGRect titleF;
@property (nonatomic , assign) CGRect urlF;
@property (nonatomic , assign) CGRect ctimeF;

@property (nonatomic , assign) CGFloat cellH;

@end
