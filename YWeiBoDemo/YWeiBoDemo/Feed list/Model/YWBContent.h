//
//  YWBContent.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBaseModel.h"

/// 卡片类型 (这里随便写的，只适配了微博中常见的类型)
typedef NS_ENUM(NSInteger, YWBStatusCardType) {
    YWBStatusCardTypeNone = 0, ///< 没卡片
    YWBStatusCardTypeNormal,   ///< 一般卡片布局
    YWBStatusCardTypeVideo,    ///< 视频
};

NS_ASSUME_NONNULL_BEGIN
@class YWBStatus;

@interface YWBContent : YBaseModel

@property (nonatomic, weak) YWBStatus *status;

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

// 转发
@property (nonatomic, assign) CGFloat retweetHeight; //转发高度，0为没转发
@property (nonatomic, assign) CGFloat retweetTextHeight;
@property (nonatomic, strong) YYTextLayout *retweetTextLayout; //被转发文本
@property (nonatomic, assign) CGFloat retweetPicHeight;
@property (nonatomic, assign) CGSize retweetPicSize;
@property (nonatomic, assign) CGFloat retweetCardHeight;
@property (nonatomic, assign) YWBStatusCardType retweetCardType;
@property (nonatomic, strong) YYTextLayout *retweetCardTextLayout; //被转发文本
@property (nonatomic, assign) CGRect retweetCardTextRect;

// 卡片
@property (nonatomic, assign) CGFloat cardHeight; //卡片高度，0为没卡片
@property (nonatomic, assign) YWBStatusCardType cardType;
@property (nonatomic, strong) YYTextLayout *cardTextLayout; //卡片文本
@property (nonatomic, assign) CGRect cardTextRect;


@end

NS_ASSUME_NONNULL_END
