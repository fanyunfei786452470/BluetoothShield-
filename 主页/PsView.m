//
//  PsView.m
//  音频盾Demo
//
//  Created by wuyangfan on 16/11/11.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "PsView.h"
#import "NISTInPutView.h"

@interface PsView ()<NISTInPutViewDelegate>

@end

@implementation PsView


- (void)drawRect:(CGRect)rect {
    NISTInPutView *inputView = [[NISTInPutView alloc] init];
    inputView.delegate = self;
    self.psTextF.inputView = inputView;
    
}

- (IBAction)getPinClick:(id)sender {
    [self.psTextF resignFirstResponder];
    [NIST1000 getRamdonPin];
}

- (IBAction)submitPinClick:(id)sender {
    [self.psTextF resignFirstResponder];
    
    NSDictionary *dict = [NIST1000 checkPinCode:self.psTextF.text];
    if ([dict[@"ResponseCode"] intValue] == 1) {
        [Tools showHUD:@"密码验证通过" done:YES];
        [self removeFromSuperview];
    }
}

- (void)numBtnWithString:(NSString *)string{
    self.psTextF.text = [self.psTextF.text stringByAppendingString:string];
}

- (void)del{
    if (self.psTextF.text.length == 0) {
        return;
    }
    self.psTextF.text = [self.psTextF.text substringWithRange:NSMakeRange(0, self.psTextF.text.length - 1)];
}

@end
