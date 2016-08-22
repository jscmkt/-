//
//  LoginViewController.m
//  新闻
//
//  Created by spare on 16/7/21.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AddNameAndPicViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}
- (IBAction)loginFinish:(id)sender {
    [BmobUser loginInbackgroundWithAccount:self.nameField.text andPassword:self.passwordField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            BmobUser *userget = [BmobUser getCurrentUser];
            AddNameAndPicViewController *add = [AddNameAndPicViewController new];
            NSString *nick = [userget objectForKey:@"nick"];
            if (nick.length>0&&[userget objectForKey:@"headPath"]) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self presentViewController:[[UINavigationController alloc]initWithRootViewController:add] animated:YES completion:nil];
            }
            
                    }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的账号和密码" preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}
- (IBAction)gotoRegister:(id)sender {
    [self.navigationController pushViewController:[RegisterViewController new
                                                   ] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
