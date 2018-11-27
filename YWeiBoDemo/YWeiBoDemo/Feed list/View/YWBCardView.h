//
//  YWBCardView.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YWBFeedListCell,YWBStatus;
@interface YWBCardView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) YWBFeedListCell *cell;

- (void)setStatus:(YWBStatus *)status isRetweet:(BOOL)isRetweet;

@end

NS_ASSUME_NONNULL_END
