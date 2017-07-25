//
//  AppDelegate.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "AppDelegate.h"
#import "Tools.h"
#import "CustAlertView.h"

@interface AppDelegate (){
    CustAlertView *_cv;
    
}

@end

@implementation AppDelegate

int linkNum;

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions{
    self.isSaveAccount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Save_Account"] intValue];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NIST_DataSource *dataSource = [NIST_DataSource sharedDataSource];
    dataSource.userInfoDic = @{@"bal":@"1000000", @"bankCardId":@"622612345678123", @"realName":@"张三"};
//    [NIST_SDK_Interface shareNISTInterface];
    
    [self initNotification];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:24.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:249/255.0f green:0/255.0f blue:13/255.0f alpha:1.0]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:hvc];
  
    
    self.window.rootViewController = nvc;
    
    self.lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [hvc presentViewController:self.lvc animated:NO completion:nil];

    dispatch_async(dispatch_queue_create("my.concurrent.appload", DISPATCH_QUEUE_CONCURRENT), ^(){
        
        /*
         
         */
    });
    return YES;
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag - 50) {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
            [_cv removeFromSuperview];
        }
            break;
        case 1:
        {
            [_cv removeFromSuperview];
        }
            break;
        case 2:
        {
         
            
      
        }
            break;
        case 3:
        {
            [_cv removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioRouteChanged:) name:@"NIST_AUDIO" object:nil];
}

- (void)AudioRouteChanged:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"NIST_AUDIO_BOOL"] intValue] == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Select_ContainerName"];
        self.signType = [NSString stringWithFormat:@"%d",0];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.isSaveAccount] forKey:@"Save_Account"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Select_ContainerName"];
    self.signType = [NSString stringWithFormat:@"%d",0];
}




@end
