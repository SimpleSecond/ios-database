//
//  WDAdvertiseView.h
//  sqlite3
//
//  Created by WangDongya on 2018/1/29.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import <UIKit/UIKit.h>

// 视图类型
typedef enum {
    WDAdvertiseViewTypeLogo = 1,
    WDAdvertiseViewTypeFullScreen = 2,
}WDAdvertiseViewType;

// 事件类型
typedef enum {
    WDAdvertiseViewEventSkip = 1,     // 跳过事件
    WDAdvertiseViewEventActiveAd = 2, // 点击广告
    WDAdvertiseViewEventOvertime = 3, // 超时事件
}WDAdvertiseViewEvent;


// 回调Block
typedef void(^WDAdvertiseClickBlock) (const WDAdvertiseViewEvent);


@interface WDAdvertiseView : UIView

@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, assign) NSInteger adTime;
// 本地图片地址
@property (nonatomic, copy) NSString *localAdImageStr;
// 网络图片URL
@property (nonatomic, copy) NSString *imageUrl;
// 事件回调
@property (nonatomic, copy) WDAdvertiseClickBlock clickBlock;


// 广告视图类型
- (void(^)(WDAdvertiseViewType const adType))getAdvertiseViewType;



@end
