//
//  AppDelegate.m
//  sqlite3
//
//  Created by WangDongya on 2018/1/29.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AppDelegate+WDAdvertiseExtension.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)wd_loadAdvertiseView
{
    __weak typeof(self) weakSelf = self;
    [AppDelegate launchAdvertiseView:^(WDAdvertiseView *advertiseView) {
        // 设置广告类型
        advertiseView.getAdvertiseViewType(WDAdvertiseViewTypeLogo);
        [advertiseView setBackgroundColor:[UIColor redColor]];
        // 设置广告图片地址
        advertiseView.imageUrl = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
        
        // 设置点击事件的回调
        advertiseView.clickBlock = ^(WDAdvertiseViewEvent event) {
            ViewController *vc = [[ViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            
            switch (event) {
                case WDAdvertiseViewEventActiveAd:
                    NSLog(@"点击广告回调");
                    [weakSelf.window.rootViewController presentViewController:vc animated:YES completion:nil];
                    break;
                    
                case WDAdvertiseViewEventSkip:
                    NSLog(@"点击跳过回调");
                    [weakSelf.window.rootViewController presentViewController:vc animated:YES completion:nil];
                    break;
                case WDAdvertiseViewEventOvertime:
                    NSLog(@"倒计时完成后的回调");
                    [weakSelf.window.rootViewController presentViewController:vc animated:YES completion:nil];
                    break;
                default:
                    break;
            }
        };
        
    }];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self wd_loadAdvertiseView];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
