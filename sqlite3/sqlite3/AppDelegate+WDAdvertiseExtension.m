//
//  AppDelegate+WDAdvertiseExtension.m
//  sqlite3
//
//  Created by WangDongya on 2018/1/30.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "AppDelegate+WDAdvertiseExtension.h"


@implementation AppDelegate (WDAdvertiseExtension)

+ (void)launchAdvertiseView:(void(^)(WDAdvertiseView *))block
{
    WDAdvertiseView *imgView = [[WDAdvertiseView alloc] init];
    block(imgView);
}

@end
