//
//  AppDelegate.m
//  database
//
//  Created by WangDongya on 2018/1/23.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+WDAdExtension.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    __weak typeof(self) weakSelf = self;
    [AppDelegate wd_ad_launchAdImageView:^(WDAdvertiseView *imgAdView) {
        // 设置广告类型
        imgAdView.getAdImageViewType(WDAdViewTypeLogo);
        NSLog(@"******");

        // 设置本地启动图片
        //imgAdView.localAdImgName = @"qidong.gif";
        imgAdView.imgUrl = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
        // 自定义跳过按钮
        //imgAdView.skipBtn.backgroundColor = [UIColor blackColor];

        // 各种点击事件的回调
        imgAdView.clickBlock = ^(const WDAdViewEvent event) {

            ViewController *vc = [[ViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];

            switch (event) {
                case WDAdViewEventClickAD:
                    NSLog(@"点击广告回调");
                    [weakSelf.window.rootViewController presentViewController:vc animated:YES completion:nil];
                    break;

                case WDAdViewEventSkipAD:
                    NSLog(@"点击跳过回调");
                    [weakSelf.window.rootViewController presentViewController:vc animated:YES completion:nil];
                    break;
                case WDAdViewEventOvertimeAD:
                    NSLog(@"倒计时完成后的回调");
                    [weakSelf.window.rootViewController presentViewController:vc animated:YES completion:nil];
                    break;
                default:
                    break;
            }
        };
    }];
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
