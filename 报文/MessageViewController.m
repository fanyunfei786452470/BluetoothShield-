//
//  MessageViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "MessageViewController.h"
#import "AppDelegate.h"
#import "NISTInPutView.h"

@interface MessageViewController ()<UIScrollViewDelegate, UITextFieldDelegate, NISTInPutViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *pinLabel;
@property(nonatomic,strong)UITextField *pinTextF;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)NSMutableDictionary *signDataInfo;
@property(nonatomic,strong)UIButton *btn;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报文签名";
    [self setNavigationBackItem];
    [self setNavigationRightButtonImage:@"Button-rightNav"];
    
    
//    if (![NIST_BlueTooth sharedNIST_BlueTooth].isConnect) {
//        [Tools showHUD:@"当前未连接蓝牙设备，请连接" done:NO];
//        return;
//    }
//    if (![NIST_BlueTooth sharedNIST_BlueTooth].isBluetoothNoti) {
//        [Tools showHUD:@"当前的蓝牙设备的通知没有打开" done:NO];
//        return;
//    }
//    
//    if([[NIST_BlueTooth sharedNIST_BlueTooth] open_Application] == 0)
//    {
//        [Tools showHUD:@"打开应用失败" done:NO];
//        return;
//    }
//    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_queue_create("my.concurrent.loadData", DISPATCH_QUEUE_CONCURRENT), ^(){
        [self loadData];
    });
}

- (void)loadView{
    [super loadView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(0, 2*SCREEN_HEIGHT);
    
    self.pinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 50)];
    self.pinLabel.text = @"PIN码:";
    self.pinLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [self.scrollView addSubview:self.pinLabel];
    
    self.pinTextF = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH - 90 - 10, 50)];
    self.pinTextF.secureTextEntry = YES;
    self.pinTextF.borderStyle = UITextBorderStyleLine;
    self.pinTextF.font = [UIFont boldSystemFontOfSize:20.0f];
    self.pinTextF.delegate = self;
    NISTInPutView *inputView = [[NISTInPutView alloc] init];
    inputView.delegate = self;
    self.pinTextF.inputView = inputView;
    [self.scrollView addSubview:self.pinTextF];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20, 900)];
    self.textLabel.layer.borderWidth = 1.0;
    self.textLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.textLabel];
}

- (void)loadData{
    self.signDataInfo = [[NSMutableDictionary alloc] init];
    NSString *textStr = [self readFileContent:@"signdata1.xml"];
    if (textStr == nil || [textStr isKindOfClass:[NSNull class]] || textStr.length <= 0) {
        [Tools showHUD:@"报文不存在，请检查文件" done:NO];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(){
            [Tools showHUD:@"报文已找到" done:YES];
            self.textLabel.text = textStr;
        });
    }
}


#pragma mark - readFile Content

-(NSString *)readFileContent:(NSString *)local_filename
{
    //    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *docPath = [ doc objectAtIndex:0];
    //    NSString *filePath = [docPath stringByAppendingPathComponent:Local_filename];
    NSArray *nameArray = [local_filename componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:nameArray[0] ofType:nameArray[1]];
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    
    
    if(fileData == nil)
    {
        return nil;
    }
    NSString* myString = [NSString stringWithUTF8String:[fileData bytes]];
    
    if(myString == nil)
    {
        NSStringEncoding strinEncod = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        myString = [[NSString alloc] initWithData:fileData encoding:strinEncod];
    }
    return myString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)navigationRightButtonAction{
    [self.view endEditing:YES];
    
    if (self.textLabel.text.length <= 0) {
        [Tools showHUD:@"当前报文不存在" done:NO];
        return;
    }
    
    if (_pinTextF.text == nil || _pinTextF.text.length <= 0 || [_pinTextF.text isKindOfClass:[NSNull class]]) {
        [Tools showHUD:@"PIN码为空" done:NO];
        [_pinTextF becomeFirstResponder];
        return;
    }
    
    NSDictionary *dict0 = [NIST1000 checkPinCode:_pinTextF.text];
    if ([dict0[@"ResponseCode"] intValue] != 1) {
        [Tools showHUD:dict0[@"ResponseError"] done:NO];
        return;
    }
  
    NSData *data = [self.textLabel.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.signDataInfo setObject:data forKey:@"signData"];
    
    NSDictionary *dict;
    [Tools showHUD:@"正在确认信息的是否正确"];
    if ([[AppDelegate sharedAppDelegate].signType intValue] == 1) {
        dict = [NIST1000 usingRSAForSignDataWithSignData:data withConfirmationViewBlock1:^{
            [Tools showHUD:@"确认，请按两次OK，否则，请按取消"];
        } withConfirmationViewBlock2:^{
             [Tools showHUD:@"确认，请按OK，否则，请按取消"];
        }];
    }else{
        dict = [NIST1000 usingECCForSignDataWithSignData:data withConfirmationViewBlock1:^{
            [Tools showHUD:@"确认，请按两次OK，否则，请按取消"];
        } withConfirmationViewBlock2:^{
            [Tools showHUD:@"确认，请按OK，否则，请按取消"];
        }];
    }
    if (dict != nil) {
        if ([dict[@"ResponseCode"] intValue] == -1 ) {
            [Tools showHUD:dict[@"ResponseError"] done:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setResultUIwithDict:dict];
        });
    }
    [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%d",0];
}

- (void)setResultUIwithDict:(NSDictionary *)dict{
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    self.pinTextF = nil;
    self.pinLabel = nil;
    self.textLabel = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    UILabel *rsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 20, 60)];
    rsLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    rsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:rsLabel];
    
    if ([dict[@"ResponseCode"] intValue] == 1) {
        [Tools showHUD:@"转账成功" done:YES];
        rsLabel.text = @"转账成功";
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 20, 400)];
        textView.userInteractionEnabled = NO;
        textView.text = [dict[@"ResponseData"] description];
        textView.font = [UIFont systemFontOfSize:15.0f];
        [self.view addSubview:textView];
    }else if ([dict[@"ResponseCode"] intValue] == -1){
        [Tools showHUD:@"转账失败" done:NO];
        rsLabel.text = @"转账失败";
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 20, 100)];
        reasonLabel.textAlignment = NSTextAlignmentCenter;
        reasonLabel.text = dict[@"ResponseError"];
        [self.view addSubview:reasonLabel];
        
    }else if ([dict[@"ResponseCode"] intValue] == 0){
        [Tools showHUD:@"取消转账" done:NO];
        rsLabel.text = @"取消转账";
    }else if ([dict[@"ResponseCode"] intValue] == 2){
        [Tools showHUD:@"已超时" done:NO];
        rsLabel.text = @"已超时";
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = nil;
    [Tools showHUD:@"正在获取随机密码"];
    NSDictionary *dict = [NIST1000 getRamdonPin];
    if ([dict[@"ResponseCode"] intValue] == 1) {
        [Tools showHUD:@"获取随机密码成功" done:YES];
    }else{
        [Tools showHUD:dict[@"ResponseError"] done:NO];
    }
}

- (void)numBtnWithString:(NSString *)string{
    self.pinTextF.text = [self.pinTextF.text stringByAppendingString:string];
}

- (void)del{
    if (self.pinTextF.text.length == 0) {
        return;
    }
    self.pinTextF.text = [self.pinTextF.text substringWithRange:NSMakeRange(0, self.pinTextF.text.length - 1)];
}


@end
