//
//  YWBTagStruct.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

/// 最下方Tag类型，也是随便写的，微博可能有更多类型同时存在等情况
typedef NS_ENUM(NSUInteger, YWBStatusTagType) {
    YWBStatusTagTypeNone = 0, ///< 没Tag
    YWBStatusTagTypeNormal,   ///< 文本
    YWBStatusTagTypePlace,    ///< 地点
};

NS_ASSUME_NONNULL_BEGIN

@interface YWBTagStruct : YBaseModel

@property (nonatomic, strong) NSString *tag_name;    ///< 标签名字，例如"上海·上海文庙"
@property (nonatomic, strong) NSString *tag_scheme;  ///< 链接 sinaweibo://...
@property (nonatomic, assign) NSInteger tag_type;    ///< 1 地点 2其他
@property (nonatomic, assign) NSInteger tag_hidden;
@property (nonatomic, strong) NSURL *url_type_pic;   ///< 需要加 _default

// layout
@property (nonatomic, assign) CGFloat tagHeight; //Tip高度，0为没tip
@property (nonatomic, assign) YWBStatusTagType tagType;
@property (nonatomic, strong) YYTextLayout *tagTextLayout; //最下方tag

@end

NS_ASSUME_NONNULL_END
