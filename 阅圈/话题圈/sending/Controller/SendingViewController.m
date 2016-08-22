//
//  SendingViewController.m
//  新闻
//
//  Created by spare on 16/7/24.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "SendingViewController.h"
#import <YYTextView.h>
#import "FaceView.h"
#import "FaceUtils.h"
#import "MBProgressHUD.h"
@interface SendingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YYTextViewDelegate>


@property (nonatomic, strong) IBOutlet UIView *buttonView;

@property (nonatomic, strong)YYTextView *titleTV;
@property (nonatomic, strong)YYTextView *detailTV;
@property (nonatomic, strong)YYTextView *currentTV;








@property (nonatomic, strong)FaceView *faceView;
//********多选图片相关
@property (nonatomic, strong)UIScrollView *selectedImageSV;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;


@property (nonatomic, strong)UIScrollView *pickerSV;
@property (nonatomic, strong)UIButton *addImageButton;
@property (nonatomic, strong)NSMutableArray *selectedImageViews;
@end

@implementation SendingViewController
- (IBAction)clicked:(UIButton*)sender {
    switch (sender.tag) {
        case 0://图片
            self.currentTV.inputView = self.currentTV.inputView? nil : self.selectedImageSV;
            [self.currentTV reloadInputViews];
            if (self.selectedImageViews.count == 0) {
                UIImagePickerController *pick = [UIImagePickerController new];
                pick.delegate = self;
                [self presentViewController:pick animated:YES completion:nil];
            }
            break;
            
        case 1:
            self.currentTV.inputView = self.currentTV.inputView ? nil : self.faceView;
            [self.currentTV reloadInputViews];
            break;
            default:
            break;
    }
}
-(UIScrollView *)selectedImageSV{
    if (!_selectedImageSV) {
        _selectedImageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
        self.addImageButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 100, 140)];
        [self.addImageButton setImage:[UIImage imageNamed:@"1.png"] forState:(UIControlStateNormal)];
        [self.selectedImageSV addSubview:self.addImageButton];
        [self.addImageButton addTarget:self action:@selector(addImageAction) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    return _selectedImageSV;
}
-(void)addImageAction{
    if (self.selectedImageViews.count<9) {
        UIImagePickerController *pick = [UIImagePickerController new];
        pick.delegate = self;
        [self presentViewController:pick animated:YES completion:nil];
    }
}

-(FaceView *)faceView{
    
    if (_faceView==nil) {
        _faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    }
    
    return _faceView;
    
}

//    标题
-(YYTextView *)titleTV{
    if (!_titleTV) {
        YYTextView *titleTV=[[YYTextView alloc]initWithFrame:CGRectMake(Margin, 64, SCREEN_WIDTH-2*Margin, 30)];
        titleTV.delegate = self;
        titleTV.placeholderText=@"标题  (可选)";
        
        titleTV.placeholderFont=[UIFont systemFontOfSize:14];
        titleTV.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:titleTV];
        _titleTV = titleTV;
        [FaceUtils faceBindingWithTextView:_titleTV];
        
        [self.buttonView removeFromSuperview];
        _titleTV.inputAccessoryView = self.buttonView;
        
    }
    return _titleTV;
}

-(YYTextView *)detailTV{
    if (!_detailTV) {
        YYTextView *detailTV=[[YYTextView alloc]initWithFrame:CGRectMake(Margin, 115, SCREEN_WIDTH-2*Margin, 150)];
        detailTV.delegate = self;
        [FaceUtils faceBindingWithTextView:detailTV];
        [self.view addSubview:detailTV];
        _detailTV=detailTV;
        
        _detailTV.inputAccessoryView = self.buttonView;
    }
    return _detailTV;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.currentTV resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.titleTV becomeFirstResponder];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.selectedImageViews = [NSMutableArray array];
    //坚挺表情按钮通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(faceBtnAction:) name:@"FaceNotification" object:nil];
}
//点击表情按钮时监听事件
-(void)faceBtnAction:(NSNotification *)noti{
    NSString *text = noti.object;
    
    [self.currentTV insertText:text];
    
    
}

-(void)initUI{
    self.imageCountLabel.layer.cornerRadius = 8;
    self.imageCountLabel.layer.masksToBounds = YES;
    self.imageCountLabel.hidden = YES;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 97, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [self.view addSubview:line];
    [self.titleTV becomeFirstResponder];
    self.detailTV.text = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStyleDone) target:self action:@selector(sendAction)];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)sendAction{
    if (self.titleTV.text.length==0&&self.detailTV.text.length==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入标题或文本" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    BmobObject *bObj = [BmobObject objectWithClassName:@"HomeObj"];
    [bObj setObject:@(0) forKey:@"showCount"];
    [bObj setObject:@(0) forKey:@"commentCount"];
    
    [bObj setObject:self.titleTV.text forKey:@"title"];
    [bObj setObject:self.detailTV.text forKey:@"detail"];
    [bObj setObject:[BmobUser getCurrentUser] forKey:@"user"];
    if (self.selectedImageViews.count>0) {
        NSMutableArray *imageArr = [NSMutableArray array];
        
        for (int i = 0; i<self.selectedImageViews.count; i++) {
            UIImageView *iv = self.selectedImageViews[i];
            NSData *imageData = UIImageJPEGRepresentation(iv.image, .5);
            [imageArr addObject:@{@"data":imageData,@"filename":[NSString stringWithFormat:@"%d.ipg",i]}];
        }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"Loading...";
            [BmobFile filesUploadBatchWithDataArray:imageArr progressBlock:^(int index, float progress) {
                hud.labelText = [NSString stringWithFormat:@"%d/%ld",index+1,self.selectedImageViews.count];
                hud.progress = progress;
                NSLog(@"%f",progress);
            } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                [hud hide:YES];
                if (isSuccessful) {
                    NSMutableArray *imagePaths = [NSMutableArray array];
                    for (BmobFile *file in array) {
                        [imagePaths addObject:file.url];
                        
                    }
                    [bObj setObject:imagePaths forKey:@"imagePaths"];
                    [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"保存成功!");
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }else{
                            NSLog(@"保存失败:%@",error);
                        }
                    }];
                }else{
                    NSLog(@"上传图片失败");
                }
            }];
            
        }else{
            [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"保存成功!");
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    
}
-(void)textViewDidBeginEditing:(YYTextView *)textView{
    self.currentTV = textView;
}

#pragma mark 多选图片相关
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(self.selectedImageViews.count*80, 0, 80, 80)];
    iv.image = info[UIImagePickerControllerOriginalImage];
    [self.pickerSV addSubview:iv];
    iv.userInteractionEnabled = YES;
    [self.selectedImageViews addObject:iv];
    self.pickerSV.contentSize = CGSizeMake(self.selectedImageViews.count*80, 0);
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
    [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [delBtn setTitle:@"X" forState:(UIControlStateNormal)];
    [delBtn setTitleColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1] forState:(UIControlStateNormal)];
    [iv addSubview:delBtn];
    if (self.selectedImageViews.count == 9) {
        [self doneAction];
    }
}
-(void)deleteAction:(UIButton*)btn{
    [self.selectedImageViews removeObject:btn.superview];
    [btn.superview removeFromSuperview];
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv = self.selectedImageViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame = CGRectMake(i*80, 0, 80, 80);
        }];
    }
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count==2) {
        //得到的sv 把高度-100
        UIView *cv = [viewController.view.subviews firstObject];
        cv.height -= 100;
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
        v.backgroundColor = [UIColor whiteColor];
        [viewController.view addSubview:v];
        self.pickerSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 80)];
        self.pickerSV.backgroundColor = GrayColor;
        [v addSubview:self.pickerSV];
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 20)];
        [doneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        doneBtn.backgroundColor = [UIColor grayColor];
        [v addSubview:doneBtn];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:(UIControlEventTouchUpInside)];
        //把之前选择的图片添加进去
        for (int i=0; i<self.selectedImageViews.count; i++) {
            UIImageView *iv = self.selectedImageViews[i];
            iv.frame = CGRectMake(i*80, 0, 80, 80);
            UIButton *delBtn = [iv.subviews firstObject];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.pickerSV addSubview:iv];
        }
    }
}
-(void)doneAction{
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv = self.selectedImageViews[i];
        iv.frame = CGRectMake(20+120*i, 30, 100, 140);
        
        [self.selectedImageSV addSubview:iv];
        UIButton *delBtn = [iv.subviews firstObject];
        [delBtn addTarget:self action:@selector(svDeleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [delBtn setTitleColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1] forState:(UIControlStateNormal)];
        iv.userInteractionEnabled = YES;
        [iv addSubview:delBtn];
    }
    self.selectedImageSV.contentSize = CGSizeMake((self.selectedImageViews.count+1)*120, 0);
    self.addImageButton.center = CGPointMake(20+self.selectedImageViews.count*120+self.addImageButton.bounds.size.width/2, self.addImageButton.center.y);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)svDeleteAction:(UIButton*)btn{
    [self.selectedImageViews removeObject:btn.superview];
    [btn.superview removeFromSuperview];
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv = self.selectedImageViews[i];
        [UIView animateWithDuration:.5 animations:^{
            iv.frame = CGRectMake(20+i*120, 30, 100, 140);
        }];
    }
    self.selectedImageSV.contentSize = CGSizeMake(20+(self.selectedImageViews.count+1)*120, 0);
    [UIView animateWithDuration:.5 animations:^{
        self.addImageButton.center = CGPointMake(20+self.selectedImageViews.count*120+50, self.addImageButton.center.y);;
    
    }];
    
}
-(void)updateImageCountLabel{
    self.imageCountLabel.hidden = self.selectedImageViews.count==0?YES:NO;
    self.imageCountLabel.text = @(self.selectedImageViews.count).stringValue;
}
@end
