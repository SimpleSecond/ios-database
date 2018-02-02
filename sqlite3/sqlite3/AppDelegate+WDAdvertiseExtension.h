//
//  AppDelegate+WDAdvertiseExtension.h
//  sqlite3
//
//  Created by WangDongya on 2018/1/30.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "AppDelegate.h"
#import "WDAdvertiseView.h"

@interface AppDelegate (WDAdvertiseExtension)

+ (void)launchAdvertiseView:(void(^)(WDAdvertiseView *))block;

@end
