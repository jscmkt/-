//
//  DetailWebViewController.m
//  新闻
//
//  Created by spare on 16/7/18.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "DetailWebViewController.h"
#import "DetailImageWebModel.h"
#import "DetailWebModel.h"
#import "PhotoBroswerVC.h"
@interface DetailWebViewController ()<UIWebViewDelegate>
@property (nonatomic , strong) DetailWebModel *detailModel;
@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic , copy) NSString *url;
@property(nonatomic,assign)int i;
@property(nonatomic,assign)CGFloat weight;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong)NSMutableArray *count;
@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    
}
-(void)setupUI{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 54, 44)];
    [btn setImage:[UIImage imageNamed:@"night_icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.backgroundColor = [UIColor whiteColor];
    webView.y = 64;
    webView.height = SCREEN_HEIGHT-64;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
}
-(void)setupData{
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.dataModel.docid];
    NSLog(@"%@",url);
    self.url = url;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.detailModel = [DetailWebModel detailWithDict:responseObject[self.dataModel.docid]];
        if ([self.detailModel.body rangeOfString:@"使用安卓和iPhone最新版本客户端可获得更流畅体验"].location == NSNotFound) {
            if ([self.detailModel.body rangeOfString:@"您的新闻客户端版本太低啦"].location == NSNotFound) {
                [self showInWebView];
            }else{
                
                [self notFound];
            }
        }else{
            
            [self gotoWebView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        self.detailModel = [DetailWebModel detailWithDict:responseObject[self.dataModel.docid]];
//        if ([self.detailModel.body rangeOfString:@"使用安卓和iPhone最新版本客户端可获得更流畅体验"].location == NSNotFound) {
//            if ([self.detailModel.body rangeOfString:@"您的新闻客户端版本太低啦"].location == NSNotFound) {
//                [self showInWebView];
//            }else{
//            
//                [self notFound];
//            }
//        }else{
//            
//            [self gotoWebView];
//        }
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
}
-(void)notFound{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您想要要的新闻君找不到了" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self backBtnClick];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)gotoWebView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"将要跳转其他网页查看详情" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self backBtnClick];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.href]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)showInWebView{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html><head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\"></head>",[[NSBundle mainBundle] URLForResource:@"Detail.css" withExtension:nil] ];
    [html appendString:@"<body>"];
    [html appendString:[self body]];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
    
}
-(NSString *)body{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    //遍历img
    for (DetailImageWebModel *detailImageModel in self.detailModel.img) {
        [self.count addObject:detailImageModel];
        NSMutableString *imgHtml = [NSMutableString string];
        
        //设置image的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        self.i++;
        //数组存放被切割的像素
        NSArray *pixel = [detailImageModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject] floatValue];
        CGFloat height = [[pixel lastObject] floatValue];
        self.weight = width;
        self.height = height;
        //判断是否超出最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
        if (width>maxWidth) {
            height = maxWidth / width *height;
            width = maxWidth-15;
        }
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImageModel.src];
        //结束标记
        [imgHtml appendString:@"</div>"];
        //替换标记
        [body replaceOccurrencesOfString:detailImageModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return  body;
}
#pragma mark - 将发出通知时调用
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location !=NSNotFound) {
        NSInteger begin = range.location +range.length;
        NSString *src = [url substringFromIndex:begin];
        [self savePictureToAlbum:src];
        return NO;
    }
    return YES;
}
- (void)savePictureToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)backBtnClick
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

@end
