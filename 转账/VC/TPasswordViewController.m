//
//  TPasswordViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "TPasswordViewController.h"

#import "AppDelegate.h"
#import "Tools.h"
#import "AcountCell.h"
#import "PsView.h"
#import "NISTInPutView.h"


@interface TPasswordViewController ()<UITableViewDelegate, UITableViewDataSource, NISTInPutViewDelegate, UITextFieldDelegate>{
    UITextField *_textF;
    UIView *_bgView;
    UILabel *_titleLabel;
    NSArray *_dataArray;
    
}
@property(nonatomic,strong)NSData *random;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation TPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.title = @"转账签名";
    [self setNavigationBackItem];
    [self setNavigationRightButtonImage:@"Button-rightNav"];
    _dataArray = @[@"PayMoney",@"PayeeName",@"PayeeBankCardId",@"PayeeBankName",@"PayDes"];
}

- (void)loadView{
    [super loadView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 50)];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.borderColor = [[UIColor grayColor] CGColor];
    _bgView.layer.borderWidth = 1;
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    _titleLabel.text = @"PIN码：";
    _titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [_bgView addSubview:_titleLabel];
    
    _textF = [[UITextField alloc] initWithFrame:CGRectMake(100 + 10, 0, SCREEN_WIDTH - 40 - 110 - 10, 50)];
    _textF.secureTextEntry = YES;
    _textF.borderStyle = UITextBorderStyleNone;
    _textF.font = [UIFont boldSystemFontOfSize:20.0f];
    _textF.delegate = self;
    NISTInPutView *inputView = [[NISTInPutView alloc] init];
    inputView.delegate = self;
    _textF.inputView = inputView;
    [_bgView addSubview:_textF];
}


- (void)navigationLeftButtonAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)navigationRightButtonAction{
    [self.view endEditing:YES];
    [Tools showHUD:@"正在确认信息的是否正确"];
    
    if (_textF.text == nil || _textF.text.length <= 0 || [_textF.text isKindOfClass:[NSNull class]]) {
        [Tools showHUD:@"PIN码为空" done:NO];
        [_textF becomeFirstResponder];
        return;
    }
    
    NSDictionary *dict0 = [NIST1000 checkPinCode:_textF.text];
    if ([dict0[@"ResponseCode"] intValue] != 1) {
        [Tools showHUD:dict0[@"ResponseError"] done:NO];
        return;
    }

    INT32 str[4] = {0};
    long val = [[NSDate date]timeIntervalSince1970];
    str[3] = (Byte) (val & 0x000000ff);
    str[2] = (Byte) ((val >> 8) & 0x0000ff);
    str[1] = (Byte) ((val >> 16) & 0x00ff);
    str[0] = (Byte) (val >> 24);
    NSString *realTime = [NSString stringWithFormat:@"%02x%02x%02x%02x",str[0],str[1],str[2],str[3]];

    [self.infoDict setObject:realTime forKey:@"UTCTime"];

    NSDictionary *dict = [NIST1000 transferAccountsWithSerialNumber:[NIST_DataSource sharedDataSource].tokenSN withUTC:self.infoDict[@"UTCTime"] withAccountNum:self.infoDict[@"PayeeBankCardId"] withMoney:self.infoDict[@"PayMoney"] withName:self.infoDict[@"PayeeName"] withConfirmationViewBlock1:^{
        [Tools showHUD:@"确认，请按两次OK，否则，请按取消"];
    } withConfirmationViewBlock2:^{
        [Tools showHUD:@"确认，请按OK，否则，请按取消"];
    }];
    if ([dict[@"ResponseCode"] intValue] == -1) {
        [Tools showHUD:dict[@"ResponseError"] done:NO];
    }else if ([dict[@"ResponseCode"] intValue] == 0) {
        [Tools showHUD:dict[@"ResponseError"] done:YES];
    }else{
        [Tools showHUD:dict[@"ResponseError"] done:NO];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeUIwithDictionary:dict];
    });
}

- (void)changeUIwithDictionary:(NSDictionary *)dict{
    [_bgView removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;

    if (dict != nil) {
        if ([dict[@"ResponseCode"] intValue] == 1) {
            self.title = @"转账成功";
            [Tools showHUD:@"转账成功" done:YES];
        }else{
            self.title = @"转账失败";
            [Tools showHUD:dict[@"ResponseError"] done:NO];
        }
    }else{
        self.title = @"转账失败";
        [Tools showHUD:@"交易中断" done:YES];
    }

    UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT - 400)/ 2, SCREEN_WIDTH - 20, _dataArray.count*44 + 80) style:UITableViewStylePlain];
    tab.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorColor = [UIColor blackColor];
    [self.view addSubview:tab];
    tab.layer.borderWidth = 0.5;
    tab.layer.borderColor = [[UIColor blackColor] CGColor];
    tab.userInteractionEnabled = NO;

    if ([tab respondsToSelector:@selector(setSeparatorInset:)]) {
        [tab setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tab respondsToSelector:@selector(setLayoutMargins:)])  {
        [tab setLayoutMargins:UIEdgeInsetsZero];
    }

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    tab.tableHeaderView = headView;

    UIView *light = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5, headView.frame.size.width, 0.5)];
    light.backgroundColor = [UIColor blackColor];
    [headView addSubview:light];

    UILabel *resLabel = [[UILabel alloc] init];
    resLabel.textAlignment = NSTextAlignmentCenter;
    resLabel.textColor = [UIColor redColor];
    resLabel.font = [UIFont boldSystemFontOfSize:22.0f];


    resLabel.frame = CGRectMake(0, 0, headView.frame.size.width, headView.frame.size.height - 0.5);
    resLabel.text = @"转账成功";
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5 - 30, headView.frame.size.width, 30)];
    reasonLabel.text = [NSString stringWithFormat:@"校验码：%@",dict[@"recordInfo"]];
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:reasonLabel];

    if (dict != nil) {
        if ([dict[@"ResponseCode"] intValue] == 1) {
            resLabel.text = @"转账成功";
            reasonLabel.text = [NSString stringWithFormat:@"校验码：%@",dict[@"ResponseResult"]];
        }else{
            resLabel.text = @"转账失败";
            reasonLabel.text = [NSString stringWithFormat:@"失败原因：%@",dict[@"ResponseError"]];
        }
    }else{
        self.title = @"转账失败";
        resLabel.text = @"转账失败";
        reasonLabel.text = @"失败原因：交易中断";
    }

    [headView addSubview:resLabel];
     [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%d",0];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    [@"PayMoney",@"PayeeName",@"PayeeBankCardId",@"PayeeBankName",@"PayDes"];
    NSString *keyStr = _dataArray[indexPath.row];
    AcountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AcountCell" owner:self options:nil] lastObject];
    if ([keyStr isEqualToString:@"PayMoney"]) {
        cell.keyLabel.text = @"转账金额";
        cell.valveLabel.text = [Tools formatMoney:self.infoDict[keyStr]];
    }else if ([keyStr isEqualToString:@"PayeeName"]){
        cell.keyLabel.text = @"转账人姓名";
        cell.valveLabel.text = self.infoDict[keyStr];
    }else if ([keyStr isEqualToString:@"PayeeBankCardId"]){
        cell.keyLabel.text = @"银行卡号";
        cell.valveLabel.text = [Tools formateBankAccount:self.infoDict[keyStr]];
    }else if ([keyStr isEqualToString:@"PayeeBankName"]){
        cell.keyLabel.text = @"银行";
        cell.valveLabel.text = self.infoDict[keyStr];
    }else{
        cell.keyLabel.text = @"附言";
        cell.valveLabel.text = self.infoDict[keyStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    _textF.text = [_textF.text stringByAppendingString:string];
}

- (void)del{
    if (_textF.text.length == 0) {
        return;
    }
    _textF.text = [_textF.text substringWithRange:NSMakeRange(0, _textF.text.length - 1)];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
