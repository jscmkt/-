//
//  TopViewController.m
//  新闻
//
//  Created by spare on 16/6/29.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "TopViewController.h"
#import "AFNetworking.h"
#import "TopData.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
@interface TopViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)TopData *topData;
@property(nonatomic,assign)int count;
@property(nonatomic,copy)NSString *setname;
@property(nonatomic,strong)NSMutableArray *totalArray;
@property(nonatomic,strong)UIImageView *imageV;
@end

@implementation TopViewController
-(NSMutableArray *)totalArray{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initUI];
    [self initNetWork];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
}

-(void)initUI{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-49-20)];
    scroll.backgroundColor = [UIColor blackColor];
    scroll.delegate = self;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    ///返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, 25, 40, 40);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backbtn];
    
    //下载按钮
    UIButton *downbtn = [[UIButton alloc]init];
    downbtn.frame = CGRectMake(SCREEN_WIDTH-5-40, backbtn.frame.origin.y, 40, 40);
    [downbtn setBackgroundImage:[UIImage imageNamed:@"arrow237"] forState:(UIControlStateNormal)];
    [downbtn addTarget:self action:@selector(downClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:downbtn];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, SCREEN_HEIGHT-70-49, SCREEN_WIDTH-55, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //数量
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, titleLabel.frame.origin.y, 50, 15)];
    countLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:countLabel];
    self.countLabel = countLabel;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH-15, 60)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
    self.textView = textView;
}
-(void)initNetWork{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:self.url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //总数
        self.count = [responseObject[@"imgsum"] intValue];
        self.setname = responseObject[@"setname"];
        
        NSArray *dataArray = [TopData objectArrayWithKeyValuesArray:responseObject[@"photos"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (TopData *data in dataArray) {
            [statusFrameArray addObject:data];
        }
        [self.totalArray addObjectsFromArray:statusFrameArray];
        [self setLabel];
        [self setImageView];
    } failure:nil];
//    [mgr GET:self.url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        //总数
//        self.count = [responseObject[@"imgsum"] intValue];
//        self.setname = responseObject[@"setname"];
//        
//        NSArray *dataArray = [TopData objectArrayWithKeyValuesArray:responseObject[@"photos"]];
//        NSMutableArray *statusFrameArray = [NSMutableArray array];
//        for (TopData *data in dataArray) {
//            [statusFrameArray addObject:data];
//        }
//        [self.totalArray addObjectsFromArray:statusFrameArray];
//        [self setLabel];
//        [self setImageView];
//    } failure:nil];
    
}
-(void)setLabel{
    //标题
    self.titleLabel.text=self.setname;
    //数量
    NSString *countNum = [NSString stringWithFormat:@"1/%d",self.count];
    self.countLabel.text = countNum;
    //内容
    [self setContentWithIndex:0];
    
}
-(void)setContentWithIndex:(int)index{
    NSString *content = [self.totalArray[index] note];
    NSString *contentTitle = [self.totalArray[index] imgtitle];
    if (content.length!=0) {
        self.textView.text = content;
        
    }else{
        self.textView.text = contentTitle;
    }
}
-(void)setImageView{
    
    for (int i =0; i<self.count; i++) {
        CGFloat imageH = self.scroll.frame.size.height-100;
        CGFloat imageW = self.scroll.frame.size.width;
        CGFloat imageY = 0;
        CGFloat imageX = i *imageW;
        UIImageView *imaV = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imaV.contentMode = UIViewContentModeCenter;
        imaV.contentMode = UIViewContentModeScaleAspectFit;
        [self.scroll addSubview:imaV];
    }
    [self setImgWithIndex:0];
    self.scroll.contentOffset = CGPointZero;
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width*self.count, 0);
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.pagingEnabled = YES;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = self.scroll.contentOffset.x/ self.scroll.frame.size.width;
    NSLog(@"%d",index);
    //添加图片
    [self setImgWithIndex:index];
    //添加文字
    
    NSString *countNum = [NSString stringWithFormat:@"%d/%d",index+1,self.count];
    self.countLabel.text = countNum;
    [self setContentWithIndex:index];
}
-(void)setImgWithIndex:(int)i{
    UIImageView *photoImgView = nil;
    if (i == 0) {
        photoImgView = self.scroll.subviews[i+2];
    }else{
        photoImgView = self.scroll.subviews[i];
    }
    NSURL *purl = [NSURL URLWithString:[self.totalArray[i] imgurl]];
    if (photoImgView.image == nil) {
        [photoImgView sd_setImageWithURL:purl placeholderImage:nil];
        self.imageV = photoImgView;
    }
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
}
-(void)downClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定保存到相册吗？" preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.imageV.image, self, nil, nil) ;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
