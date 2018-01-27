//
//  WDAdvertiseView.m
//  database
//
//  Created by WangDongya on 2018/1/25.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "WDAdvertiseView.h"
#import <SDWebImage/UIImageView+WebCache.h>



#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width


@interface WDAdvertiseView ()
{
    NSTimer *countDownTimer;
}
@property (nonatomic, strong) NSString *isClick;

@end


@implementation WDAdvertiseView

#pragma mark - 获取广告类型
- (void (^)(WDAdViewType adType))getAdImageViewType
{
    [self setBackgroundColor:[UIColor redColor]];
    __weak typeof(self) weakSelf = self;
    return ^(WDAdViewType adType) {
        // 添加广告图片
        [weakSelf addLaunchAdImageViews:adType];
    };
}


#pragma mark - 加载视图

- (void)addLaunchAdImageViews:(WDAdViewType)adType
{
    NSLog(@"******-----");
    // ios开发 强制竖屏。 系统KVO 强制竖屏->使用于支持各种方向屏幕启动时，竖屏展示广告  by : nixs
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
    // 倒计时
    _adTime = 6;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    NSString *launchImageName = [self getLaunchImage:@"Portrait"];
    UIImage *launchImage = [UIImage imageNamed:launchImageName];
    self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
    self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
    
    if (adType == WDAdViewTypeFullScreen) {
        self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    } else {
        self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight - mainWidth / 3)];
    }
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(mainWidth - 70, 20, 60, 30);
    self.skipBtn.backgroundColor = [UIColor blackColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.skipBtn addTarget:self action:@selector(skipBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.adImageView addSubview:self.skipBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.skipBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.skipBtn.layer.mask = maskLayer;
    self.adImageView.tag = 1101;
    [self addSubview:self.adImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activateAdTap:)];
    // 允许用户交互
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView addGestureRecognizer:tap];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = 0.0;
    opacityAnim.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.8];
    opacityAnim.fillMode = kCAFillModeForwards;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.adImageView.layer addAnimation:opacityAnim forKey:@"animateOpacity"];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    NSLog(@"******-----");
}

#pragma mark - 计时器
- (void)onTimer
{
    if (_adTime == 0) {
        [countDownTimer invalidate];
        countDownTimer = nil;
        [self startCloseAnimation];
    } else {
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_adTime--)] forState:UIControlStateNormal];
    }
}


#pragma mark - 设置本地广告图片
- (void)setLocalAdImg:(NSString *)localAdImg
{
    _localAdImg = localAdImg;
    if (_localAdImg.length > 0) {
        if ([_localAdImg rangeOfString:@".gif"].location != NSNotFound) {
            _localAdImg = [_localAdImg stringByReplacingOccurrencesOfString:@".gif" withString:@""];
            
            NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_localAdImg ofType:@"gif"]];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.adImageView.frame];
            webView.backgroundColor = [UIColor clearColor];
            webView.scalesPageToFit = YES;
            webView.scrollView.scrollEnabled = NO;
            [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
            [webView setUserInteractionEnabled:NO];
            UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clearBtn.frame = webView.frame;
            [clearBtn addTarget:self action:@selector(activateAdTap:) forControlEvents:UIControlEventTouchUpInside];
            [webView addSubview:clearBtn];
            [self.adImageView addSubview:webView];
            [self.adImageView bringSubviewToFront:_skipBtn];
        } else {
            self.adImageView.image = [UIImage imageNamed:_localAdImg];
        }
    }
}


#pragma mark - 设置网络图片
- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [self.adImageView setImage:[self wd_imageCompress4width:image targetWidth:mainWidth]];
        }
    }];
}


#pragma mark - 点击广告
- (void)activateAdTap:(UITapGestureRecognizer *)tap
{
    _isClick = @"1";
    [self startCloseAnimation];
}

#pragma mark - 点击跳过
- (void)skipBtnTap
{
    _isClick = @"2";
    [self startCloseAnimation];
}



#pragma mark - 开启关闭动画
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
                                   selector:@selector(closeAdImageAnimation)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark - 关闭动画完成时，处理事件
- (void)closeAdImageAnimation
{
    [countDownTimer invalidate];
    countDownTimer = nil;
    self.hidden = YES;
    self.adImageView.hidden = YES;
    [self removeFromSuperview];
    
    if ([_isClick integerValue] == 1) {
        if (self.clickBlock) { // 点击广告
            self.clickBlock(WDAdViewEventClickAD);
        }
    } else if ([_isClick integerValue] == 2) {
        if (self.clickBlock) { // 点击跳过
            self.clickBlock(WDAdViewEventSkipAD);
        }
    } else {
        if (self.clickBlock) { // 超时事件
            self.clickBlock(WDAdViewEventOvertimeAD);
        }
    }
}


#pragma mark - 获取LaunchImage的名称
- (NSString *)getLaunchImage:(NSString *)viewOrientation
{
    // 获取启动图片
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    // 横屏请设置成  @"Landscape" | Portrait
    // NSString *viewOrientation = @"Portrait";
    __block NSString *launchImageName = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    [imagesDict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize imageSize = CGSizeFromString(obj[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:obj[@"UILaunchImageOrientation"]]) {
            launchImageName = obj[@"UILaunchImageName"];
        }
    }];
    return launchImageName;
}

#pragma mark - 指定宽度按比例缩放
- (UIImage *)wd_imageCompress4width:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) ==  NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImage == nil) {
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}




@end
