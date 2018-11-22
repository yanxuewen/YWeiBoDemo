//
//  AppDelegate+AppService.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (AppService)

- (void)initWindow;
- (void)initDDLog;
- (void)monitorNetworkStatus;   /// 监听网络状态

// AppDelegate
+ (AppDelegate *)shareAppDelegate;

@end

NS_ASSUME_NONNULL_END
