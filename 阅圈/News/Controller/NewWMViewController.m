//
//  NewWMViewController.m
//  新闻
//
//  Created by spare on 16/6/22.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "NewWMViewController.h"
#import "MainViewController.h"

@interface NewWMViewController ()<WMPageControllerDataSource>

@end

@implementation NewWMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"新闻";
}

-(NSArray *)titles{
    return @[@"头条",@"精选",@"财经",@"娱乐",@"军事",@"游戏",@"体育",@"科技",@"时尚"/*,@"汽车"*/];
}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}
-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    MainViewController *mnv = [[MainViewController alloc]init];
    if (index==0) {
        
        mnv.context = @"T1348647853363";
        mnv.type = @"headline";
        mnv.automoble = @"article";
        return mnv;
    }
    else{
        
        
        
        switch (index) {
            case 1:
                mnv.type = @"list";
                mnv.context = @"T1467284926140";
                mnv.automoble = @"article";
                return mnv;
                
            case 2:
                mnv.type = @"list";
                mnv.context = @"T1348648756099";
                mnv.automoble = @"article";
                return mnv;
            case 3:
                mnv.type = @"list";
                mnv.context = @"T1348648517839";
                mnv.automoble = @"article";
                return mnv;
                //                otherViewController.content = @"huabian";
                //                return otherViewController;
            case 4:
                mnv.type = @"list";
                mnv.context = @"T1348648141035";
                mnv.automoble = @"article";
                return mnv;
            case 5:
                mnv.type = @"list";
                mnv.context = @"T1348654151579";
                mnv.automoble = @"article";
                return mnv;
            case 6:
                mnv.type = @"list";
                mnv.context = @"T1348649079062";
                mnv.automoble = @"article";
                return mnv;
                //                otherViewController.content = @"tiyu";
                //                return otherViewController;
            case 7:
                mnv.type = @"list";
                mnv.context = @"T1348649580692";
                mnv.automoble = @"article";
                return mnv;
                //                otherViewController.content = @"keji";
                //                return otherViewController;
                
            case 8:
                mnv.type = @"list";
                mnv.context = @"T1348650593803";
                mnv.automoble = @"article";
                return mnv;
                //                otherViewController.content = @"qiwen";
                //                return otherViewController;
          /*case 9:
                mnv.type = @"list";
                mnv.context = @"5LiK5rW3";
                mnv.automoble = @"auto";
                return mnv;*/
        }
        return mnv;
    }
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    return self.titles[index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
//    return self.viewControllers.count;
//}
//-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
//    switch (index) {
//        case 0:{
//            return [[MainNewsViewController alloc]init];
//        }
//            
//            break;
//            
//        default:
//            return [[OtherViewController alloc]init];
//            break;
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
