//
//  DetailViewController.m
//  新闻
//
//  Created by spare on 16/7/27.
//  Copyright © 2016年 spare. All rights reserved.
//

#import "DetailViewController.h"
#import "FaceView.h"
#import <YYTextView.h>
#import "MBProgressHUD.h"
#import "HomeObj.h"
#import "HomeObjectView.h"
#import "CommentCell.h"
#import "FaceUtils.h"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentBarView;
@property (nonatomic, strong)YYTextView *commentTV;

@property (nonatomic, strong)NSArray *comments;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@property (nonatomic, strong)FaceView *faceView;
//********多选图片相关
@property (nonatomic, strong)UIScrollView *selectedImageSV;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@property (nonatomic, strong)UIScrollView *pickerSV;
@property (nonatomic, strong)UIButton *addImageButton;
@property (nonatomic, strong)NSMutableArray *selectedImageViews;
@end

@implementation DetailViewController
-(NSArray *)comments{
    if (!_comments) {
        _comments = [NSArray array];
    }
    return _comments;
}
- (IBAction)sendAction:(id)sender {
    BmobObject *bObj = [BmobObject objectWithClassName:@"Comment"];
    //设置文本
    [bObj setObject:self.commentTV.text forKey:@"text"];
    //谁发送的
    [bObj setObject:[BmobUser getCurrentUser] forKey:@"user"];
    //评论的哪一条消息
    [bObj setObject:self.hObj.bobj forKey:@"source"];
    //设置图片
    if (self.selectedImageViews.count>0) {
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i =0 ; i<self.selectedImageViews.count; i++) {
            UIImageView *iv = self.selectedImageViews[i];
            NSData *imageData = UIImageJPEGRepresentation(iv.image, .5);
            [imageArr addObject:@{@"data":imageData,@"filename":[NSString stringWithFormat:@"%d.jpg",i]}];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Loading...";
        //开始上传文件
        [BmobFile filesUploadBatchWithDataArray:imageArr progressBlock:^(int index, float progress) {
            hud.labelText = [NSString stringWithFormat:@"%d/%ld",index+1,self.selectedImageViews.count];
            hud.progress = progress;
            
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            [hud hide:YES];
            if (isSuccessful) {
                NSMutableArray *imagePaths = [NSMutableArray array];
                for (BmobFile *file in array) {
                    [imagePaths addObject:file.url];
                }
                //把图片数组添加到评论对象中
                [bObj setObject:imagePaths forKey:@"imagePaths"];
                [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [self commentSuccessAction];
                    }else{
                        NSLog(@"commentcell保存失败:%@",error);
                    }
                }];
            }else{
                NSLog(@"保存失败%@",error);
            }
        }];
    }else{
        [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            [self commentSuccessAction];
        }];
    }
}
-(void)loadComments{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    
    //设置查询条件
    [query whereKey:@"source" equalTo:self.hObj.bobj];
//    //设置返回数据包含user字段
    [query includeKey:@"user"];
    
    //设置时间倒序
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"%ld",array.count);
//        NSMutableArray *hObjs = [NSMutableArray array];
//        for (BmobObject *bObj in array) {
//            HomeObj *hObj = [[HomeObj alloc]initWith:bObj];
//            [hObjs addObject:hObj];
//            
//        }
//        self.comments
        //把BmobObject数组专成自定义的Comment对象数组
        
        
            self.comments = [Comment commentArrayFromBmobObjectArray:array];
            NSLog(@"dis%ld",self.comments.count);
            [self.tableView reloadData];
        
        
        
    }];
    
    
}
-(void)commentSuccessAction{
    //评论量+1
    [self.hObj addCommentCountWithCompletionBlock:^(id obj) {
        
    }];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论成功" preferredStyle:(UIAlertControllerStyleAlert)];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self loadComments];
        [self.commentTV resignFirstResponder];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
    
}
- (IBAction)clicked:(UIButton*)sender {
    switch (sender.tag) {
        case 0://图片
            self.commentTV.inputView = self.commentTV.inputView?nil:self.selectedImageSV;
            [self.commentTV reloadInputViews];
            if (self.selectedImageViews.count==0) {
                UIImagePickerController *pick = [UIImagePickerController new];
                pick.delegate = self;
                [self presentViewController:pick animated:self completion:nil];
            }
            break;
            case 1://表情
            self.commentTV.inputView = self.commentTV.inputView?nil:self.faceView;
            [self.commentTV reloadInputViews];
            break;
        default:
            break;
    }
}
-(UIScrollView *)selectedImageSV{
    if (!_selectedImageSV) {
        _selectedImageSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
        self.addImageButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 100, 140)];
        [self.addImageButton setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        [self.selectedImageSV addSubview:self.addImageButton];
        [self.addImageButton addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedImageSV;
}
-(void)addImageAction
{
    if (self.selectedImageViews.count<9) {
        UIImagePickerController *pick=[UIImagePickerController new];
        pick.delegate=self;
        [self presentViewController:pick animated:YES completion:nil];
    }
}
- (IBAction)commentAction:(id)sender {
    if ([BmobUser getCurrentUser]) {
        if (!self.commentTV.isFirstResponder) {
        [self.commentTV becomeFirstResponder];
    }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(FaceView *)faceView{
    
    if (_faceView==nil) {
        _faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    }
    
    return _faceView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadComments];
    NSLog(@"VC%ld",self.comments.count);
    self.title = @"详情";
    self.selectedImageViews = [NSMutableArray array];
    self.imageCountLabel.layer.cornerRadius = self.imageCountLabel.size.width/2;
    self.imageCountLabel.layer.masksToBounds = YES;
    self.imageCountLabel.hidden = YES;
    self.commentBarView.y = SCREEN_HEIGHT;
    self.commentTV = [[YYTextView alloc]initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-150, 40)];
    self.commentTV.layer.cornerRadius = 5;
    self.commentTV.layer.masksToBounds = YES;
    self.commentTV.backgroundColor = GrayColor;
    [self.commentBarView addSubview:self.commentTV];
//    self.commentTV.inputView = self.commentTV.inputView?nil:self.commentTV;
//    [self.commentTV reloadInputViews];
    [self.view bringSubviewToFront:self.commentBarView];
    [FaceUtils faceBindingWithTextView:self.commentTV];
    //键盘监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBtnAction:) name:@"FaceNotification" object:nil];
//    [self loadComments];
    self.tableView = [UITableView new];
    self.tableView .frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    HomeObjectView *objView = [[HomeObjectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self.hObj getHeigth]+10)];
    objView.hObj = self.hObj;
    self.tableView .tableHeaderView = objView;
    [self.view sendSubviewToBack:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@--%@",self.navigationController.topViewController,self);
    //选择图片回来之后要把软键盘弹出来
    if (self.selectedImageViews.count!=0) {
        [self.commentTV becomeFirstResponder];
    }
}
//点击表情按钮时监听事件
-(void)faceBtnAction:(NSNotification *)noti{
    NSString *text = noti.object;
    
    [self.commentTV insertText:text];
    
    
}
-(void)keyboardFrameChange:(NSNotification*)noti{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        
        //判断软键盘是否弹出
        if (keyboardF.origin.y==SCREEN_HEIGHT) {//收键盘
            self.commentBarView.transform = CGAffineTransformIdentity;
            
        }else{//软件盘弹出的时候 把表情隐藏
            self.commentBarView.transform = CGAffineTransformMakeTranslation(0, -keyboardH-50);
            
            
        }
    }];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.commentTV resignFirstResponder];
//    [self.tableView becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"num%ld",self.comments.count);
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSLog(@"num%ld",self.comments.count);
    cell.comment = self.comments[indexPath.row];
    
    
    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Comment *c = self.comments[indexPath.row];
    
    return 55 + [c getHeigth];
    
}

#pragma mark 多选图片相关
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    UIImageView *iv=[[UIImageView alloc]initWithFrame:CGRectMake(self.selectedImageViews.count*80, 0, 80, 80)];
    iv.image=info[UIImagePickerControllerOriginalImage];
    [self.pickerSV addSubview:iv];
    iv.userInteractionEnabled=YES;
    [self.selectedImageViews addObject:iv];
    self.pickerSV.contentSize=CGSizeMake(self.selectedImageViews.count*80, 0);
    UIButton *delBtn =[[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
    [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setTitle:@"X" forState:UIControlStateNormal];
    [delBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [iv addSubview:delBtn];
    if(self.selectedImageViews.count==9)
    {
        [self doneAction];
        
    }
    
    
    
    
    
}
-(void)deleteAction:(UIButton *)btn
{
    [self.selectedImageViews removeObject:btn.superview];
    [btn.superview removeFromSuperview];
    for(int i=0;i<self.selectedImageViews.count;i++)
    {
        UIImageView *iv=self.selectedImageViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame=CGRectMake(i*80, 0, 80, 80);
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    
    if(navigationController.viewControllers.count==2)
    {
        UIView *cv = [viewController.view.subviews firstObject];
        cv.height -= 100;
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
        [viewController.view addSubview:v];
        self.pickerSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 80)];
        self.pickerSV.backgroundColor=GrayColor;
        [v addSubview:self.pickerSV];
        UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 20)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        doneBtn.backgroundColor=[UIColor grayColor];
        [v addSubview:doneBtn];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        //把之前选择的图片添加进去
        for(int i=0;i<self.selectedImageViews.count;i++)
        {
            UIImageView *iv=self.selectedImageViews[i];
            
            iv.frame=CGRectMake(i*80, 0, 80, 80);
            UIButton *delBtn = [iv.subviews firstObject];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.pickerSV addSubview:iv];
        }
    }
}
-(void)doneAction
{
    
    
    
    
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv=self.selectedImageViews[i];
        iv.frame = CGRectMake(20+120*i, 30, 100, 140);
        
        
        [self.selectedImageSV addSubview:iv];
        UIButton *delBtn= [iv.subviews firstObject];
        [delBtn addTarget:self action:@selector(svdeleteaction:) forControlEvents:UIControlEventTouchUpInside];
        
        [delBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        iv.userInteractionEnabled=YES;
        [iv addSubview:delBtn];
        
    }
    
    self.selectedImageSV.contentSize=CGSizeMake((self.selectedImageViews.count+1)*120, 0);
    
    self.addImageButton.center = CGPointMake(20+self.selectedImageViews.count*120+self.addImageButton.bounds.size.width/2, self.addImageButton.center.y);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateImageCountLabel];
}

-(void)svdeleteaction:(UIButton *)btn
{
    [self.selectedImageViews removeObject:btn.superview];
    [btn.superview removeFromSuperview];
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv=self.selectedImageViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame=CGRectMake(20+i*120, 30, 100, 140);
            
        }];
        
    }
    
    self.selectedImageSV.contentSize = CGSizeMake(20+(self.selectedImageViews.count+1)*120, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.addImageButton.center=CGPointMake(20+self.selectedImageViews.count*120+50, self.addImageButton.center.y);
    }];
    [self updateImageCountLabel];
}
-(void)updateImageCountLabel{
    
    self.imageCountLabel.hidden = self.selectedImageViews.count==0?YES:NO;
    
    self.imageCountLabel.text = @(self.selectedImageViews.count).stringValue;
    
}


@end
