//
//  YWBStatusTitle.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YWBStatusTitle : YBaseModel

@property (nonatomic, assign) NSInteger base_color;
@property (nonatomic, strong) NSString *text;       ///< 文本，例如"仅自己可见"
@property (nonatomic, strong) NSString *icon_url;   ///< 图标URL，需要加Default

// layout
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) YYTextLayout *titleTextLayout;

@end

NS_ASSUME_NONNULL_END
