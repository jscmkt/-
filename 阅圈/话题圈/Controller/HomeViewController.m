//
//  HomeViewController.m
//  新闻
//
//  Created by spare on 16/7/22.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "HomeViewController.h"
#import "MJExtension.h"
#import "GYHHeadeRefreshController.h"
#import "SendingViewController.h"
#import "HomeObj.h"
#import "HomeCell.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *objs;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UITableView *tableView =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self initNavigationbar];
    [self setupRefreshView];
    [tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
}

-(void)setupRefreshView{
    //下拉刷新
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.header = header;
    [header beginRefreshing];
    
    //上拉刷新
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

#pragma mark 下拉
-(void)loadNew{
    
    [self loadMessagesWithSkipCount:0];
    [self.tableView.header endRefreshing];
}
-(void)loadMore{
    [self loadMessagesWithSkipCount:self.objs.count];
    [self.tableView.footer endRefreshing];
}
-(void)initNavigationbar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(sendingAction)];
}
-(void)sendingAction{
    if ([BmobUser getCurrentUser]) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[SendingViewController new]] animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *seletedIndexPath = [self.tableView indexPathForSelectedRow];
    if (seletedIndexPath) {
        //刷新
        [self.tableView reloadRowsAtIndexPaths:@[seletedIndexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        //取消选中效果
        [self.tableView deselectRowAtIndexPath:seletedIndexPath animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.objs.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.hObj = self.objs[indexPath.row];
    return cell;
}
-(void)loadMessagesWithSkipCount:(long)count{
    BmobQuery *query = [BmobQuery queryWithClassName:@"HomeObj"];
    //查询时如果有某个字段是bmobObject类型 需要查询时设置包含
    [query includeKey:@"user"];
    
    //设置请求数量为20
    query.limit =20;
    //设置跳过的消息数量
    query.skip = count;
    
    //判断是否显示自己的消息
//    if (self.showSelfInfo) {
//        [query whereKey:@"user" equalTo:[BmobUser getCurrentUser]];
//    }
    [query orderByDescending:@"createdAt"];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置查询请求
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *hObjs = [NSMutableArray array];
        for (BmobObject *bObj in array) {
            HomeObj *hObj = [[HomeObj alloc]initWith:bObj];
            [hObjs addObject:hObj];
            
        }
        //请求第一页
        if (query.skip==0) {
            self.objs = hObjs;
            
        }else{//不是第一页
            [self.objs addObjectsFromArray:hObjs];
            
        }
        [self.tableView reloadData];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeObj *hObj = self.objs[indexPath.row];
    return 60+[hObj getHeigth];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 通过点击的位置得到cell
    HomeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    
    
    HomeObj *itObj = self.objs[indexPath.row];
    
    //让浏览量增加1
    [itObj addShowCountWithCompletionBlock:^(id obj) {
        
        cell.hObj = obj;
    }];
    
    
    
    DetailViewController *vc = [DetailViewController new];
    vc.hObj = itObj;
    [self.navigationController pushViewController:vc animated:YES];
    
 
    
    
}
@end
