//
//  WDAdvertiseView.m
//  sqlite3
//
//  Created by WangDongya on 2018/1/29.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "WDAdvertiseView.h"



#define MAIN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define MAIN_HEIGHT  [UIScreen mainScreen].bounds.size.height



@interface WDAdvertiseView()
{
    NSTimer *_countdownTimer;
}
@property (nonatomic, strong) NSString *isClick;


@end


@implementation WDAdvertiseView

#pragma mark - 获取广告类型
- (void (^)(const WDAdvertiseViewType))getAdvertiseViewType
{
    __weak typeof(self) weakSelf = self;
   
    return ^(WDAdvertiseViewType adType){
        // 添加广告图片
        [weakSelf loadAdvertiseImageViews:adType];
    };
}

#pragma mark - 加载广告视图
- (void)loadAdvertiseImageViews:(WDAdvertiseViewType)adType
{
    // iOS开发 强制竖屏。 系统KVO 强制竖屏 -> 使用于支持各种方向屏幕启动时，竖屏展示广告 by : nixs
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
    // 倒计时
    _adTime = 6;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    UIImage *launchImage = [UIImage imageNamed:@"Portrait"];
    self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
    self.frame = CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT);
    
    if (adType == WDAdvertiseViewTypeFullScreen) {
        self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)];
    } else {
        self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT - MAIN_WIDTH / 3)];
    }
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(MAIN_WIDTH - 70, 20, 60, 30);
    self.skipBtn.backgroundColor = [UIColor blackColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.skipBtn addTarget:self action:@selector(clickSkipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.adImageView addSubview:self.skipBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.skipBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.skipBtn.layer.mask = maskLayer;
    self.adImageView.tag = 1101;
    [self addSubview:self.adImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activateAdvertise:)];
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView addGestureRecognizer:tap];
    
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = 0.0;
    opacityAnim.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.8];
    opacityAnim.fillMode = kCAFillModeForwards;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.adImageView.layer addAnimation:opacityAnim forKey:@"animateOpacity"];
    
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
}


#pragma mark - Click Event

- (void)clickSkipBtn:(UIButton *)btn
{
    _isClick = @"2";
    [self startCloseAnimation];
}

- (void)activateAdvertise:(UITapGestureRecognizer *)tap
{
    _isClick = @"1";
    [self startCloseAnimation];
}

- (void)onTimer
{
    if (_adTime == 0) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;
        [self startCloseAnimation];
    } else {
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_adTime--)] forState:UIControlStateNormal];
    }
}

#pragma mark - 关闭动画
- (void)startCloseAnimation
{
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = 0.5;
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.3];
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.fillMode = kCAFillModeForwards;
    
    [self.adImageView.layer addAnimation:opacityAnim forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnim.duration
                                     target:self
                                   selector:@selector(closeAdvertiseAnimation)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)closeAdvertiseAnimation
{
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    self.hidden = YES;
    self.adImageView.hidden = YES;
    [self removeFromSuperview];
    
    if ([_isClick integerValue] == 1) {
        if (self.clickBlock) {
            self.clickBlock(WDAdvertiseViewEventActiveAd);
        }
    } else if ([_isClick integerValue] == 2) {
        if (self.clickBlock) {
            self.clickBlock(WDAdvertiseViewEventSkip);
        }
    } else {
        if (self.clickBlock) {
            self.clickBlock(WDAdvertiseViewEventOvertime);
        }
    }
}


#pragma mark - setter / getter 方法
//- (NSString *)getLaunchImage:(NSString *)orientation
//{
//    
//}


@end
