//
//  MeViewController.m
//  新闻
//
//  Created by spare on 16/7/18.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "MeViewController.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SettingItem.h"
#import "SettingCell.h"
#import "SettingGroup.h"
#import "HeaderView.h"
#import "LoginViewController.h"
#import "AddNameAndPicViewController.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *clearNum;
@property(nonatomic,strong)NSMutableArray *arrays;
@end

@implementation MeViewController
-(NSMutableArray *)arrays{
    if (!_arrays) {
        _arrays = [NSMutableArray array];
    }
    return _arrays;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self setUp];
    [self setupUI];
}

-(void)setupUI{
    UIImageView *bcIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    bcIV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    bcIV.alpha=0.1;
//    [self.view sendSubviewToBack:bcIV];
//    [self.view addSubview:bcIV];
    [self.tableView setBackgroundView:bcIV];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    HeaderView *hv = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil] firstObject];
//    hv.headerImageView.image = [UIImage imageNamed:@"headIV"];
    if ([BmobUser getCurrentUser]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goinHead)];
        hv.headerImageView.userInteractionEnabled = YES;
        [hv.headerImageView addGestureRecognizer:tap];
    }
    [hv.nameBtn addTarget:self action:@selector(login) forControlEvents:(UIControlEventTouchUpInside)];
//    if([BmobUser getCurrentUser].username ){
//        
//        hv.nameBtn.enabled = NO;
//        
//    }else{
//        hv.nameBtn.titleLabel.text = @"登录";
//        
//    }
    self.tableView.tableHeaderView = hv;
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView.subviews.firstObject.backgroundColor = [UIColor clearColor];
}
-(void)goinHead{
    AddNameAndPicViewController *add = [AddNameAndPicViewController new];
    [self.navigationController pushViewController:add animated:YES];
}
-(void)login{
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}
-(void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20) style:(UITableViewStyleGrouped)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
-(void)setUp{
    SettingItem *clearCache = [SettingItem itemWithItem:@"handShake" title:@"清除缓存" subtitle:self.clearNum];
    SettingItem *chat = [SettingItem itemWithItem:@"MoreMessage" title:@"联系我"];
    SettingItem *logout = [SettingItem itemWithItem:@"IDInfo" title:@"退出登录"];
    logout.option = ^{
        [self logout];
    };
    chat.option = ^{
        [self chat];
    };
    clearCache.option = ^{
        [self clear];
    };
    SettingGroup *group = [[SettingGroup alloc]init];
    group.items = @[clearCache,logout];
    SettingGroup *group1 = [[SettingGroup alloc]init];
    group1.items = @[chat];
    [self.arrays addObject:group];
    [self.arrays addObject:group1];
}
-(void)logout{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出？" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [BmobUser logout];
        [self setupUI];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)chat{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"有什么好的意见请联系\njscmkt@sina.com" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)clear{
    MBProgressHUD *hud = [MBProgressHUD new];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:hud];
    //加载条上显示文本
    hud.labelText = @"清理中";
    //置当前的view为灰度
    hud.dimBackground = YES;
    //设置当前对话框样式
    hud.mode = MBProgressHUDModeDeterminate;
    [hud showAnimated:YES whileExecutingBlock:^{
        while (hud.progress < 1.0) {
            hud.progress += 0.01;
            [NSThread sleepForTimeInterval:0.02];
        }
        hud.labelText = @"清理完成";
    } completionBlock:^{
        //清除磁盘缓存
        [[SDImageCache sharedImageCache] clearDisk];
        //清除内存缓存
        [[SDImageCache sharedImageCache] clearMemory];
        //清除系统网络请求时缓存的数据
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        self.clearNum = @"0.0KB";
        self.arrays = nil;
        [self setUp];
        [self.tableView reloadData];
        [hud removeFromSuperview];
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearNum = tmpSize >= 1? [NSString stringWithFormat:@"%.1fMB",tmpSize/(1024*1024)] : [NSString stringWithFormat:@"%.1fKB",tmpSize*1024];
    self.arrays = nil;
    self.clearNum = clearNum;
    [self setUp];
    HeaderView *hv = (HeaderView*)self.tableView.tableHeaderView;
    if ([BmobUser getCurrentUser]) {
        hv.user = [BmobUser getCurrentUser];
    }
    [self.tabBarController.tabBar.subviews firstObject].hidden = YES;
//    if (hv.user) {
//        hv.nameBtn.enabled = NO;
//    }
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.tabBarController.tabBar.subviews firstObject].hidden = NO;
}
#pragma mark - tableview代理数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrays.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SettingGroup *group = self.arrays[section];
    return group.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [SettingCell cellWithTableView:tableView];
    SettingGroup *group = self.arrays[indexPath.section];
    cell.item = group.items[indexPath.row];
//    cell.backgroundColor = [UIColor clearColor];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = view;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.alpha = 0.5;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    cell.selectedBackgroundView = view;
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
//    cell.selectedBackgroundView.alpha = 0.5;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingGroup *group = self.arrays[indexPath.section];
    SettingItem *item = group.items[indexPath.row];
    if (item.option) {
        item.option();
    }
}
@end
