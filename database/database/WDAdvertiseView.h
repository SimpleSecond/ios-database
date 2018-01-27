//
//  WDAdvertiseView.h
//  database
//
//  Created by WangDongya on 2018/1/25.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import <UIKit/UIKit.h>


// 广告界面显示样式
typedef enum{
    WDAdViewTypeLogo = 0,        // 含有LOGO的广告界面
    WDAdViewTypeFullScreen = 1,  // 全屏广告界面
} WDAdViewType;


// 广告界面中点击事件
typedef enum{
    WDAdViewEventSkipAD = 1,     // 点击跳过按钮
    WDAdViewEventClickAD = 2,    // 点击广告
    WDAdViewEventOvertimeAD = 3, // 超时事件
} WDAdViewEvent;


// 回调事件（block）
typedef void(^WDAdClickBlock)(const WDAdViewEvent);


// 广告界面
@interface WDAdvertiseView : UIView

@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, assign) NSInteger adTime;
// 本地图片名字
@property (nonatomic, copy) NSString *localAdImg;
// 网络图片URL
@property (nonatomic, copy) NSString *imgUrl;
// 事件回调
@property (nonatomic, copy) WDAdClickBlock clickBlock;


// 广告视图类型adViewType
- (void(^)(WDAdViewType const adType))getAdImageViewType;


@end
