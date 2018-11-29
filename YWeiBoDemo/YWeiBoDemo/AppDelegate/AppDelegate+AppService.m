//
//  AppDelegate+AppService.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "AppDelegate+AppService.h"

@implementation AppDelegate (AppService)

#pragma mark - 初始化window
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KClearColor;
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
//    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (void)initDDLog {
    //DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

- (void)initWithNavigationBar {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIColor *color = kRandomColor;
    [navBar setBarTintColor:color];
    [navBar setTintColor:color];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :KWhiteColor, NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:color] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];//去掉阴影线
}

#pragma mark - 网络监控
- (void)monitorNetworkStatus {
    RealReachability *reach = [RealReachability sharedInstance];
    reach.hostForPing = @"www.baidu.com";
    [reach startNotifier];
    [kNotificationCenter addObserver:self selector:@selector(networkStatusChanged:) name:kRealReachabilityChangedNotification object:nil];
    kWeakSelf(self);
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        [weakself networkStatusChanged:nil];
    }];
}

- (void)networkStatusChanged:(NSNotification *)noti {
    ReachabilityStatus status = GLobalRealReachability.currentReachabilityStatus;
    switch (status) {
        case RealStatusUnknown:
        case RealStatusNotReachable:
            DDLogInfo(@"Network Status Not Reachable");
            break;
            
        case RealStatusViaWWAN: {
            DDLogInfo(@"Network Status: WWAN");
            switch ([GLobalRealReachability currentWWANtype]) {
                case WWANType4G:
                    DDLogInfo(@"Network Status: 4G");
                    break;
                case WWANType3G:
                    DDLogInfo(@"Network Status: 3G");
                    break;
                case WWANType2G:
                    DDLogInfo(@"Network Status: 2G");
                    break;
                default:
                    break;
            }
        }
            break;
        case RealStatusViaWiFi:
            DDLogInfo(@"Network Status: WIFI");
            break;
        default:
            break;
    }
}

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
