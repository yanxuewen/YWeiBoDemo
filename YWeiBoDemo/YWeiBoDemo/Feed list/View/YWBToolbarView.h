//
//  YWBToolbarView.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/26.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWBToolbar.h"

NS_ASSUME_NONNULL_BEGIN
@class YWBFeedListCell;

@interface YWBToolbarView : UIView

@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) YYLabel *repostLabel;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, weak) YWBFeedListCell *cell;

@property (nonatomic, strong) YWBToolbar *toobarM;

@end

NS_ASSUME_NONNULL_END
