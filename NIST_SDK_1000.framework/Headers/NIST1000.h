//
//  NIST1000.h
//  NIST_1000
//
//  Created by wuyangfan on 16/5/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "global.h"

typedef void(^ConfirmationViewBlock)(void);

@interface NIST1000 : NSObject

+ (void)setRefaultRub:(int)defaultRub;

+ (void)send_Lajitou:(int)sendLJT Lajiwei:(int)sendLJW W:(int)sendW N:(int)sendN
      Recive_Lajitou:(int)reciveLJT Lajiwei:(int)reciveLJW W:(int)reciveW N:(int)reciveN reciveNum:(int)reciveNum;

+ (NSDictionary *)getSerialNumber;

+ (NSDictionary *)getDynamicCodeWithSerialNumber:(NSString *)serialNumber withUTC:(NSString *)utctime withConfirmationViewBlock:(ConfirmationViewBlock)confirmationViewBlock;

+ (NSDictionary *)transferAccountsWithSerialNumber:(NSString *)serialNumber withUTC:(NSString *)utctime withAccountNum:(NSString *)accountNum withMoney:(NSString *)money withName:(NSString *)name withConfirmationViewBlock1:(ConfirmationViewBlock)confirmationViewBlock1 withConfirmationViewBlock2:(ConfirmationViewBlock)confirmationViewBlock2;

+ (NSDictionary *)usingRSAForSignDataWithSignData:(NSData *)data withConfirmationViewBlock1:(ConfirmationViewBlock)confirmationViewBlock1 withConfirmationViewBlock2:(ConfirmationViewBlock)confirmationViewBlock2;

+ (NSDictionary *)usingECCForSignDataWithSignData:(NSData *)data withConfirmationViewBlock1:(ConfirmationViewBlock)confirmationViewBlock1 withConfirmationViewBlock2:(ConfirmationViewBlock)confirmationViewBlock2;

+ (NSDictionary *)readAllCertFileList;

+ (NSDictionary *)readCertFileName:(NSString *)certFileName;

+ (NSDictionary *)screenFlip;

+ (NSDictionary *)detectionPinCodeModified;

+ (NSDictionary *)getVersionInformation;

+ (NSDictionary *)changePinCodeWithOldPinCode:(NSString *)oldPinCode withNewPinCode:(NSString *)newPinCode withConfirmationViewBlock:(ConfirmationViewBlock)confirmationViewBlock;
+ (void)removeAllFile;

+ (NSDictionary *)getRamdonPin;

+ (NSDictionary *)checkPinCode:(NSString *)pinCode;
@end
