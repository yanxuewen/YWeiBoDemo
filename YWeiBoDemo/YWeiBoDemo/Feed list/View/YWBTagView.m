//
//  YWBTagView.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBTagView.h"
#import "YWBStatusHelper.h"
#import "YWBFeedListCell.h"
#import "YWBModel.h"

@implementation YWBTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0){
        frame.origin.x = kWBCellPadding;
        frame.size.width = kScreenWidth - 2*kWBCellPadding;
    }
    self = [super initWithFrame:frame];
    kWeakSelf(self);
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:[UIImage imageWithColor:kWBCellBackgroundColor] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.000 alpha:0.200]] forState:UIControlStateHighlighted];
    [_button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([weakself.cell.delegate respondsToSelector:@selector(cellDidClickTag:)]) {
            [weakself.cell.delegate cellDidClickTag:weakself.cell];
        }
    }];
    _button.hidden = YES;
    [self addSubview:_button];
    
    _label = [YYLabel new];
    _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _label.width = self.width;
    _label.displaysAsynchronously = YES;
    _label.ignoreCommonProperties = YES;
    _label.fadeOnHighlight = NO;
    _label.fadeOnAsynchronouslyDisplay = NO;
    _label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakself.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakself.cell.delegate cell:weakself.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_label];

    
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(kWBCellTagPlaceHeight, kWBCellTagPlaceHeight);
    _imageView.image = [YWBStatusHelper imageNamed:@"timeline_icon_locate"];
    _imageView.hidden = YES;
    [self addSubview:_imageView];
    
    _label.height = kWBCellTagPlaceHeight;
    _button.height = kWBCellTagPlaceHeight;
    self.height = kWBCellTagPlaceHeight;
    return self;
}

- (void)setTagM:(YWBTagStruct *)tagM {
    _tagM = tagM;
    self.height = tagM.tagHeight;
    _label.textLayout = tagM.tagTextLayout;
}

@end
