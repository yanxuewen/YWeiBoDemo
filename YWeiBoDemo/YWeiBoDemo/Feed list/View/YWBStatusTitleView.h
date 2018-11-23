//
//  YWBStatusTitleView.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YWBFeedListCell,YWBStatusTitle;
@interface YWBStatusTitleView : UIView

@property (nonatomic, weak) YWBFeedListCell *cell;
@property (nonatomic, strong) YWBStatusTitle *titleM;

@end

NS_ASSUME_NONNULL_END
