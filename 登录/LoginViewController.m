//
//  LoginViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"


@interface LoginViewController (){
    CGRect _useridFrame;
    CGRect _passFrame;
}

@property (weak, nonatomic) IBOutlet UITextField *userText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _useridFrame = self.userid.frame;
    _passFrame = self.passwd.frame;
    
    self.userid.text = @"92000008";
    self.passwd.text = @"123456";
    
    self.view.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if ([AppDelegate sharedAppDelegate].isSaveAccount) {
        
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_account"];
        if (account.length <= 0 || account == nil || [account isKindOfClass:[NSNull class]]) {
            self.saveBtn.selected = NO;
        }else{
            self.saveBtn.selected = YES;
            //self.userid.text = account;
        }
    }else{
        self.saveBtn.selected = NO;
        //self.userid.text = @"";
    }
}


- (void)loadView{
    [super loadView];
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"loginSaveDown"] forState:UIControlStateSelected];
    [self.saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userid.keyboardType = UIKeyboardTypeNumberPad;
    self.userid.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([AppDelegate sharedAppDelegate].isSaveAccount == YES) {
        self.userid.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_account"];
    }
    
    self.passwd.keyboardType = UIKeyboardTypeNumberPad;
    self.passwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwd.secureTextEntry = YES;
    
    self.saveBtn.selected = [AppDelegate sharedAppDelegate].isSaveAccount;
    
    
    self.iconImg.userInteractionEnabled = NO;
    [self.iconImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentSetVC)]];
}

- (void)presentSetVC{
    SettingViewController *svc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self presentViewController:svc animated:YES completion:nil];
}


- (void)saveClick:(UIButton *)btn{
    btn.selected = !btn.selected;
   
    if (btn.selected == YES) {
        [AppDelegate sharedAppDelegate].isSaveAccount = YES;
    }else{
        [AppDelegate sharedAppDelegate].isSaveAccount = NO;
    }
}

- (IBAction)submitLogin:(id)sender {
    [self.view endEditing:YES];
    
    [Tools showHUD:@"正在登录"];
    if (self.userid.text == nil || [self.userid.text isKindOfClass:[NSNull class]] || self.userid.text.length <= 0) {
        [Tools showHUD:@"请输入账号" done:NO];
        [self.userid becomeFirstResponder];
        return;
    }
    
    if (self.passwd.text == nil || [self.passwd.text isKindOfClass:[NSNull class]] || self.passwd.text.length <= 0) {
        [Tools showHUD:@"请输入密码" done:NO];
        [self.passwd becomeFirstResponder];
        return;
    }

    NSDictionary *dict = [NIST1000 getSerialNumber];
    if (dict != nil) {
        if ([dict[@"ResponseCode"] intValue] != 1) {
            [Tools showHUD:dict[@"ResponseError"] done:NO];
        }else{
            [Tools showHUD:@"登录成功" done:YES];
            [NIST_DataSource sharedDataSource].tokenSN = dict[@"ResponseResult"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            /*if ([dict[@"ResponseResult"] isEqualToString:self.userid.text]) {
                [Tools showHUD:@"登录成功" done:YES];
                [NIST_DataSource sharedDataSource].tokenSN = self.userid.text;
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [Tools showHUD:@"账户错误" done:NO];
            }*/
        }
    }else{
        [Tools showHUD:@"超时" done:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"loginOut 记住密码 %d",[AppDelegate sharedAppDelegate].isSaveAccount);
    if ([AppDelegate sharedAppDelegate].isSaveAccount) {
        NSLog(@"%@",[NIST_DataSource sharedDataSource].tokenSN);
        
        [[NSUserDefaults standardUserDefaults] setObject:[NIST_DataSource sharedDataSource].tokenSN forKey:@"user_account"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_account"];
    }
}


@end
