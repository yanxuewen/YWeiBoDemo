//
//  YWBStatusTitleView.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBStatusTitleView.h"
#import "YWBStatusHelper.h"
#import "YWBStatusTitle.h"

@interface YWBStatusTitleView ()

@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowButton;

@end

@implementation YWBStatusTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellTitleHeight;
    }
    self = [super initWithFrame:frame];
    _titleLabel = [YYLabel new];
    _titleLabel.size = CGSizeMake(kScreenWidth - 100, self.height);
    _titleLabel.left = kWBCellPadding;
    _titleLabel.displaysAsynchronously = YES;
    _titleLabel.ignoreCommonProperties = YES;
    _titleLabel.fadeOnHighlight = NO;
    _titleLabel.fadeOnAsynchronouslyDisplay = NO;
    [self addSubview:_titleLabel];
    
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    line.bottom = self.height;
    line.backgroundColor = kWBCellLineColor.CGColor;
    [self.layer addSublayer:line];
    self.exclusiveTouch = YES;
    return self;
}

- (void)setTitleM:(YWBStatusTitle *)titleM {
    _titleM = titleM;
    _titleLabel.textLayout = titleM.titleTextLayout;
    
}

@end
