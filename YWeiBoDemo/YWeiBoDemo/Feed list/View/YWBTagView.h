//
//  YWBTagView.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWBTagStruct.h"

NS_ASSUME_NONNULL_BEGIN

@class YWBFeedListCell,YWBStatus;

@interface YWBTagView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) YWBFeedListCell *cell;

@property (nonatomic, strong) YWBTagStruct *tagM;

@end

NS_ASSUME_NONNULL_END
