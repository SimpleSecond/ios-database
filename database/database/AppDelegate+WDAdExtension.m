//
//  AppDelegate+WDAdExtension.m
//  database
//
//  Created by WangDongya on 2018/1/26.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "AppDelegate+WDAdExtension.h"

@implementation AppDelegate (WDAdExtension)

+ (void)wd_ad_launchAdImageView:(void(^)(WDAdvertiseView *))block
{
    WDAdvertiseView *imgView = [[WDAdvertiseView alloc] init];
    block(imgView);
}

@end
