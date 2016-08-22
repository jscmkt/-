//
//  MainViewController.m
//  新闻
//
//  Created by spare on 16/6/21.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "MainViewController.h"
#import "MJExtension.h"
#import "SDCycleScrollView.h"
#import "AFNetworking.h"
#import "TopData.h"
#import "TopViewController.h"
#import "DaataModel.h"
#import "MJRefresh.h"
#import "GYHHeadeRefreshController.h"
#import "NewsCell.h"
#import "ImagesCell.h"
#import "TopViewCell.h"
#import "DetailWebViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *topArray;
@property(nonatomic,strong) NSMutableArray *totalArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,assign) int page;
@end

@implementation MainViewController
-(NSMutableArray *)topArray{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}
-(NSMutableArray *)totalArray{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
-(NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
                     
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initTopNet];
    [self setupRefreshView];
//    [self initSetupUI];
}
-(void)setupRefreshView{
    //下拉刷新
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.header = header;
    [header beginRefreshing];
    
    //上拉刷新
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark 下拉
-(void)loadNewData{
    self.page = 0;
    [self requestNet:1];
    [self.tableView.header endRefreshing];
}
-(void)loadMoreData{
    [self requestNet:2];
    [self.tableView.footer endRefreshing];
}
-(void) initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)initSetupUI{
    [self.navigationController.navigationBar.subviews firstObject].backgroundColor = [UIColor colorWithRed:250/255.0 green:240/255.0 blue:180/255.0 alpha:0.7];
}
-(void) initTopNet{
    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/%@/%@/%@/0-10.html",self.automoble,self.type,self.context];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray *dataArray = [NSArray array];
        if ([self.type isEqualToString:@"headline"]){
        dataArray = [TopData objectArrayWithKeyValuesArray:responseObject[self.context][0][@"ads"]];
        }
        for (TopData *data in dataArray) {
            [self.topArray addObject:data];
            [self.titleArray addObject:data.title];
            [self.imagesArray addObject:data.imgsrc];
            [self initSCrollView];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)initSCrollView{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.55) imageURLStringsGroup:self.imagesArray];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.titlesGroup = self.titleArray;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.tableView.tableHeaderView = cycleScrollView;
    
}
-(void)requestNet:(int)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/%@/%@/%@/%d-20.html",self.automoble,self.type,self.context,self.page];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arrayM = [NSArray array];
        if ([self.automoble  isEqualToString: @"auto"]) {
            arrayM = [DaataModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
        }else{
            arrayM = [DaataModel objectArrayWithKeyValuesArray:responseObject[self.context]];
        }
        //        NSArray *temArray = responseObject[self.context];
        //        NSArray *arrayM = [DaataModel objectArrayWithKeyValuesArray:temArray];
        NSMutableArray *statusArray = [NSMutableArray array];
        for (DaataModel *data in arrayM) {
            [statusArray addObject:data];
        }
        if (type == 1) {
            self.totalArray = statusArray;
            
        }else{
            [self.totalArray addObjectsFromArray:statusArray];
        }
        [self.tableView reloadData];
        self.page +=20;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
//    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSArray *arrayM = [NSArray array];
//        if ([self.automoble  isEqualToString: @"auto"]) {
//            arrayM = [DaataModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        }else{
//            arrayM = [DaataModel objectArrayWithKeyValuesArray:responseObject[self.context]];
//        }
////        NSArray *temArray = responseObject[self.context];
////        NSArray *arrayM = [DaataModel objectArrayWithKeyValuesArray:temArray];
//        NSMutableArray *statusArray = [NSMutableArray array];
//        for (DaataModel *data in arrayM) {
//            [statusArray addObject:data];
//        }
//            if (type == 1) {
//                self.totalArray = statusArray;
//                
//            }else{
//                [self.totalArray addObjectsFromArray:statusArray];
//            }
//            [self.tableView reloadData];
//            self.page +=20;
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DaataModel *newsModel = self.totalArray[indexPath.row];
    NSString *ID = [NewsCell idForRow:newsModel];
    if ([ID isEqualToString:@"NewsCell"]) {
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
        cell.dataModel = newsModel;
        return cell;
    }else if ([ID isEqualToString:@"ImagesCell"]){
        ImagesCell *cell = [ImagesCell cellWithTableView:tableView];
        cell.dataModel = newsModel;
        return cell;
    }
    else{
        TopViewCell *cell = [TopViewCell cellWithTableView:tableView];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DaataModel *newsModel = self.totalArray[indexPath.row];
    NSLog(@"%@",newsModel.title);
    NSString *ID = [NewsCell idForRow:newsModel];
    if ([ID isEqualToString:@"NewsCell"]) {
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.dataModel = self.totalArray[indexPath.row];
        NSLog(@"%@",detailVC.dataModel.docid);
        detailVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([ID isEqualToString:@"ImagesCell"]){
        if ([self.automoble isEqualToString:@"auto"]||[self.context isEqualToString:@"T1348649079062"]||[self.context isEqualToString:@"T1348654151579"]||[self.context isEqualToString:@"T1348648756099"]) {
            DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
            detailVC.dataModel = self.totalArray[indexPath.row];
            NSLog(@"%@",detailVC.dataModel.docid);
            detailVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
        NSString *url1 = [newsModel.photosetID substringFromIndex:4];
        url1 = [url1 substringToIndex:4];
        NSString *url2 = [newsModel.photosetID substringFromIndex:9];
        NSLog(@"%@,%@",url1,url2);
        
        url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
        TopViewController *topVC = [[TopViewController alloc]init];
        topVC.url = url2;
        [self.navigationController pushViewController:topVC animated:YES];
        
        }}else if ([ID isEqualToString:@"TopImageCell"]){
        NSLog(@"");
    }else{
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.dataModel = self.totalArray[indexPath.row];
        NSLog(@"%@",detailVC.dataModel.docid);
        detailVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DaataModel *newsModel = self.totalArray[indexPath.row];
    CGFloat rowHeight = [NewsCell heightForRow:newsModel];
    return rowHeight;
}
#pragma mark 图片轮播 delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    TopData *data = self.topArray[index];
    NSString *url1 = [data.url substringFromIndex:4];
    url1 = [url1 substringToIndex:4];
    NSString *url2 = [data.url substringFromIndex:9];
    NSLog(@"%@,%@",url1,url2);
    NSString *url3 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
    TopViewController *topVC = [TopViewController new];
    topVC.url= url3;
    [self.navigationController pushViewController:topVC animated:YES];
    
}

@end
