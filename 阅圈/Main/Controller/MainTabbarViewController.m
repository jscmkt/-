//
//  MainTabbarViewController.m
//  新闻
//
//  Created by spare on 16/6/20.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "MeViewController.h"
#import "HomeViewController.h"
#import "NewWMViewController.h"

@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NewWMViewController *nwm = [[NewWMViewController alloc]init];

    MeViewController *Me = [[MeViewController alloc]init];
    
    HomeViewController *home = [[HomeViewController alloc]init];
    [self setupChildViewController:nwm andTitle:@"新闻" andImage:@"newspaper7" andSelectedImage:@"newspaper2"];
    [self setupChildViewController:home andTitle:@"话题圈" andImage:@"huati" andSelectedImage:@"huati1"];
    [self setupChildViewController:Me andTitle:@"我" andImage:@"tabbar_setting" andSelectedImage:@"tabbar_setting_hl"];
    
    self.tabBar.tintColor = [UIColor colorWithRed:88/255.0 green:174/255.0 blue:24/255.0 alpha:1];
}
-(void)setupChildViewController:(UIViewController*)childVC andTitle:(NSString *)title andImage:(NSString*)image andSelectedImage:(NSString*)selectedImage{
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVC];
    
    [self addChildViewController:nav];
    
}
-(BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
