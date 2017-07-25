//
//  InitViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "InitViewController.h"
#import "Tools.h"
#import "AppDelegate.h"

@interface InitViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_initTableView;
    NSArray *_dataArray;
    NSArray *_containArray;
    NSString *_containName;
}
@end

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"初始化中心";
    [self setNavigationBackItem];
    [self setNavigationRightText:@"刷新"];
}

- (void)loadData{
    [Tools showHUD:@"正在读取证书"];
    NSDictionary *dict = [NIST1000 readAllCertFileList];
    if (dict != nil) {
        if ([dict[@"ResponseCode"] intValue] == 1) {
            [Tools showHUD:@"读取证书成功" done:YES];
            _dataArray = dict[@"ResponseResult"];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [_initTableView reloadData];
            });
        }else{
            [Tools showHUD:@"读取证书失败" done:NO];
        }
    }else{
        [Tools showHUD:@"获取数据超时" done:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT), ^(){
        [self loadData];
    });
    
}

- (void)loadView{
    [super loadView];
    _initTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _initTableView.dataSource = self;
    _initTableView.delegate = self;
    [self.view addSubview:_initTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Tools showHUD:@"正在初始化"];
    
    NSDictionary *dict = [NIST1000 readCertFileName:_dataArray[indexPath.row]];
    if (dict != nil) {
        if ([dict[@"ResponseCode"] intValue] == -1) {
            [Tools showHUD:dict[@"ResponseError"] done:NO];
            return;
        }else{
            [Tools showHUD:@"初始化成功" done:YES];
            [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%@",dict[@"type"]];
            NSLog(@"--->%@",[NSString stringWithFormat:@"%@",_dataArray[indexPath.row]]);
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row]] forKey:@"Select_ContainerName"];
        }
    }else{
        [Tools showHUD:@"初始化失败" done:NO];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    [btn addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"删除证书" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}

- (void)btnClcik{
    [NIST1000 removeAllFile];
    _dataArray = nil;
    [_initTableView reloadData];
}


- (void)navigationRightButtonAction{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
