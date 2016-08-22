//
//  AddNameAndPicViewController.m
//  阅圈
//
//  Created by spare on 16/7/21.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "AddNameAndPicViewController.h"
#import "UIKit+AFNetworking.h"
#import "MainTabbarViewController.h"
#import "MeViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
@interface AddNameAndPicViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headIV;
@property (weak, nonatomic) IBOutlet UITextField *nickTF;
@property(nonatomic,strong) NSData *imageData;
@property (nonatomic,strong) UIWindow *window;

@end

@implementation AddNameAndPicViewController
- (IBAction)imageAction:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//进去图片选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.headIV setImage:image forState:(UIControlStateNormal)];
    image = [self thumbnailWithImage:image size:self.headIV.frame.size];
    if ([[info[UIImagePickerControllerReferenceURL] description] hasSuffix:@"PNG"]) {
        self.imageData = UIImagePNGRepresentation(image);
        
    }else{
        self.imageData = UIImageJPEGRepresentation(image, .5);
        NSLog(@"%ld",self.imageData.length);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage*)thumbnailWithImage:(UIImage*)image size:(CGSize)size{
    UIImage *newImage = nil;
    if (image != nil) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    return newImage;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    ;
    if (self.headIV.imageView) {
        [self.headIV setTitle:nil forState:(UIControlStateNormal)];
    }

    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (self.headIV.imageView) {
//        self.headIV.titleLabel.text = nil;
//    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(doneAction)];
    NSString *nick = [[BmobUser getCurrentUser]objectForKey:@"nick"];
    if (nick.length>0) {
        self.nickTF.text = nick;
    }
    NSString *headPath = [[BmobUser getCurrentUser] objectForKey:@"headPath"];
    if (headPath) {
        [self.headIV setImageForState:(UIControlStateNormal) withURL:[NSURL URLWithString:headPath]];
        
    }else{
        [self.headIV setTitle:@"请设置头像" forState:(UIControlStateNormal)];
    }
}
-(void)doneAction{
    BmobUser *user = [BmobUser getCurrentUser];
    [user setObject:self.nickTF.text forKey:@"nick"];
    if (self.nickTF.text.length>0) {
        if (self.imageData) {
        //如果有照片先上传图片 在保存数据
        BmobFile *imagefile = [[BmobFile alloc]initWithFileName:@"abc.jpg" withFileData:self.imageData];
        NSLog(@"上传前%@",imagefile.url);
        [imagefile saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"上传完%@",imagefile.url);
                [user setObject:imagefile.url forKey:@"headPath"];
                //更新数据
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                    MainTabbarViewController *main = [MainTabbarViewController new];
//                    [UIApplication sharedApplication].keyWindow.rootViewController = [MainTabbarViewController new];
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
                    self.window.rootViewController = [MainTabbarViewController new];
                    [self.window makeKeyAndVisible];
//                    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                    app.window.rootViewController = [MainTabbarViewController new];
                    
                }];
            }else{
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }];
        
    }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认不输入昵称" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
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
