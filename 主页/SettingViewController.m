//
//  SettingViewController.m
//  音频盾Demo
//
//  Created by wuyangfan on 16/11/8.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *rbTextF;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.rbTextF.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitClick:(id)sender {
    [self.view endEditing:YES];
    if (self.rbTextF.text == nil || self.rbTextF.text.length <= 0 || [self.rbTextF.text isKindOfClass:[NSNull class]]) {
        
    }else{
        [NIST1000 setRefaultRub:[self.rbTextF.text intValue]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
