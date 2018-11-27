//
//  YWBStatusHelper.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>

// 宽高
#define kWBCellTopMargin 8                                      // cell 顶部灰色留白
#define kWBCellTitleHeight 36                                   // cell 标题高度 (例如"仅自己可见")
#define kWBCellPadding 12                                       // cell 内边距
#define kWBCellPaddingText 10                                   // cell 文本与其他元素间留白
#define kWBCellPaddingPic 4                                     // cell 多张图片中间留白
#define kWBCellProfileHeight 56                                 // cell 名片高度
#define kWBCellCardHeight 70                                    // cell card 视图高度
#define kWBCellNamePaddingLeft 14                               // cell 名字和 avatar 之间留白
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度
#define kWBCellNameWidth (kScreenWidth - 110)                   // cell 名字最宽限制

#define kWBCellTagPadding 8             // tag 上下留白
#define kWBCellTagNormalHeight 16       // 一般 tag 高度
#define kWBCellTagPlaceHeight 24        // 地理位置 tag 高度

#define kWBCellToolbarHeight 35         // cell 下方工具栏高度
#define kWBCellToolbarBottomMargin 2    // cell 下方灰色留白

// 字体 应该做成动态的，这里只是 Demo，临时写死了。
#define kWBCellNameFontSize 16          // 名字字体大小
#define kWBCellSourceFontSize 12        // 来源字体大小
#define kWBCellTextFontSize 17          // 文本字体大小
#define kWBCellTextFontRetweetSize 16   // 转发字体大小
#define kWBCellCardTitleFontSize 16     // 卡片标题文本字体大小
#define kWBCellCardDescFontSize 12      // 卡片描述文本字体大小
#define kWBCellTitlebarFontSize 14      // 标题栏字体大小
#define kWBCellToolbarFontSize 14       // 工具栏字体大小

// 颜色
#define kWBCellNameNormalColor UIColorHex(333333)                   // 名字颜色
#define kWBCellNameOrangeColor UIColorHex(f26220)                   // 橙名颜色 (VIP)
#define kWBCellTimeNormalColor UIColorHex(828282)                   // 时间颜色
#define kWBCellTimeOrangeColor UIColorHex(f28824)                   // 橙色时间 (最新刷出)

#define kWBCellTextNormalColor UIColorHex(333333)                   // 一般文本色
#define kWBCellTextSubTitleColor UIColorHex(5d5d5d)                 // 次要文本色
#define kWBCellTextHighlightColor UIColorHex(527ead)                // Link 文本色
#define kWBCellTextHighlightBackgroundColor UIColorHex(bfdffe)      // Link 点击背景色
#define kWBCellToolbarTitleColor UIColorHex(929292)                 // 工具栏文本色
#define kWBCellToolbarTitleHighlightColor UIColorHex(df422d)        // 工具栏文本高亮色

#define kWBCellBackgroundColor UIColorHex(f2f2f2)                   // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)                    // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7)                    // Cell内部卡片灰色
#define kWBCellInnerViewHighlightColor  UIColorHex(f0f0f0)          // Cell内部卡片高亮时灰色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09]  // 线条颜色

#define kWBLinkHrefName @"href"     // NSString
#define kWBLinkURLName @"url"       // WBURL
#define kWBLinkTagName @"tag"       // WBTag
#define kWBLinkTopicName @"topic"   // WBTopic
#define kWBLinkAtName @"at"         // NSString

NS_ASSUME_NONNULL_BEGIN

@interface YWBStatusHelper : NSObject

+ (UIImage *)imageNamed:(NSString *)name;
+ (UIImage *)imageWithPath:(NSString *)path;
+ (NSAttributedString *)attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink;
+ (NSAttributedString *)attachmentWithFontSize:(CGFloat)fontSize imageURL:(NSString *)imageURL shrink:(BOOL)shrink;
+ (NSString *)stringWithTimelineDate:(NSDate *)date;
+ (NSURL *)defaultURLForImageURL:(id)imageURL;
+ (YYWebImageManager *)avatarImageManager;

/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;

@end

NS_ASSUME_NONNULL_END
