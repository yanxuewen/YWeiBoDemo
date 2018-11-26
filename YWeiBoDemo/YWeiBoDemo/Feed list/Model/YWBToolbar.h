//
//  YWBToolbar.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/26.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YWBStatus;
@interface YWBToolbar : YBaseModel

@property (nonatomic, weak) YWBStatus *status;

@property (nonatomic, assign) CGFloat toolbarHeight; 
@property (nonatomic, strong) YYTextLayout *toolbarRepostTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarLikeTextLayout;
@property (nonatomic, assign) CGFloat toolbarRepostTextWidth;
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarLikeTextWidth;

+ (NSString *)shortedNumberDesc:(NSUInteger)number;

@end

NS_ASSUME_NONNULL_END
