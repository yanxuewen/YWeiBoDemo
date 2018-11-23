//
//  YWBProfileView.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWBModel.h"
@class YWBFeedListCell;

NS_ASSUME_NONNULL_BEGIN

@interface YWBProfileView : UIView

@property (nonatomic, strong) UIImageView *avatarView;      ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, assign) YWBUserVerifyType verifyType;
@property (nonatomic, weak) YWBFeedListCell *cell;

@property (nonatomic, strong) YYTextLayout *nameTextLayout;
@property (nonatomic, strong) YYTextLayout *sourceTextLayout;

@property (nonatomic, strong) YWBUser *userM;

@end

NS_ASSUME_NONNULL_END
