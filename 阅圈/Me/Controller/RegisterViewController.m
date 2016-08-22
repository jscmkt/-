//
//  RegisterViewController.m
//  新闻
//
//  Created by spare on 16/7/21.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerNew;

@property(nonatomic,strong)BmobUser *user;
@end

@implementation RegisterViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {
        //        self.registerNew.backgroundColor = [UIColor lightTextColor];
        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;
        //        self.registerNew.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.nameField.delegate = self;
    self.passwordField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRegister) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)goRegister
{
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {
        
        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;
        
    }
}
- (IBAction)registerNewName:(id)sender {
    self.user = [BmobUser new];
    self.user.username = self.nameField.text;
    self.user.password = self.passwordField.text;
    [self.user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"用户名已存在" preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {

        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;

    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {

        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;

    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {

        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;

    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {

        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;

    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.nameField.text.length>0&&self.passwordField.text.length>0) {

        self.registerNew.enabled = YES;
    }else{
        self.registerNew.enabled = NO;

    }
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
