//
//  YCommonMacros.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#ifndef YCommonMacros_h
#define YCommonMacros_h

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// 当前系统版本
#define kCurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]

//拼接字符串
#define kNSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色
#define KRGBColor(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define KClearColor         [UIColor clearColor]
#define KWhiteColor         [UIColor whiteColor]
#define KBlackColor         [UIColor blackColor]
#define KGrayColor          [UIColor grayColor]
#define KLightGrayColor     [UIColor lightGrayColor]
#define KBlueColor          [UIColor blueColor]
#define KRedColor           [UIColor redColor]
#define kRandomColor        KRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))        //随机色生成

//字体
#define kBoldFont(size)         [UIFont boldSystemFontOfSize:size]
#define kSystemFont(size)       [UIFont systemFontOfSize:size]
#define kFont(name, size)       [UIFont fontWithName:(name) size:(size)]

//定义UIImage对象
#define kImageWithFile(name)    [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", name, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define kImageName(name)        [UIImage imageNamed:name]

//数据验证
#define kStrValid(f)        (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define kSafeStr(f)         (StrValid(f) ? f:@"")
#define kHasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define kValidStr(f)        StrValid(f)
#define kValidDict(f)       (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define kValidArray(f)      (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define kValidNum(f)        (f!=nil && [f isKindOfClass:[NSNumber class]])
#define kValidClass(f,cls)  (f!=nil && [f isKindOfClass:[cls class]])
#define kValidData(f)       (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime  CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime    NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

//打印当前方法名
#define kLogFuncName NSLog(@"%s",__func__)

//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj]
#define kNotificationCenter         [NSNotificationCenter defaultCenter]

#endif /* YCommonMacros_h */
