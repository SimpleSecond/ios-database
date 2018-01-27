//
//  AppDelegate+WDAdExtension.h
//  database
//
//  Created by WangDongya on 2018/1/26.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "AppDelegate.h"
#import "WDAdvertiseView.h"

@interface AppDelegate (WDAdExtension)

+ (void)wd_ad_launchAdImageView:(void(^)(WDAdvertiseView *))block;

@end
