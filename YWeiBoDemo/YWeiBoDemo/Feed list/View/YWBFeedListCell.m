//
//  YWBFeedListCell.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBFeedListCell.h"

#import "YWBModel.h"
#import "YWBStatusTitleView.h"
#import "YWBProfileView.h"
#import "YWBToolbarView.h"

@interface YWBFeedListCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) YWBProfileView *profileView;
@property (nonatomic, strong) YWBStatusTitleView *titleView;
@property (nonatomic, strong) YWBToolbarView *toolbarView;

@property (nonatomic, strong) YYLabel *contentTextLabel;        // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    // 转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本

@end

@implementation YWBFeedListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
            break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self setupUI];
    return self;
}

- (void)setupUI {
    _containerView = [UIView new];
    _containerView.width = kScreenWidth;
    _containerView.height = 1;
    _containerView.backgroundColor = KWhiteColor;
    
    kWeakSelf(self);
    
    static UIImage *topLineBG, *bottomLineBG;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        bottomLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
    });
    UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
    topLine.width = _containerView.width;
    topLine.bottom = 0;
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_containerView addSubview:topLine];
    
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
    bottomLine.width = _containerView.width;
    bottomLine.top = _containerView.height;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_containerView addSubview:bottomLine];
    [self.contentView addSubview:_containerView];
    
    _titleView = [YWBStatusTitleView new];
    _titleView.cell = self;
    [_containerView addSubview:_titleView];
    
    _profileView = [YWBProfileView new];
    _profileView.cell = self;
    [_containerView addSubview:_profileView];
    
    _toolbarView = [YWBToolbarView new];
    _toolbarView.cell = self;
    [_containerView addSubview:_toolbarView];
    
    _retweetBackgroundView = [UIView new];
    _retweetBackgroundView.backgroundColor = kWBCellInnerViewColor;
    _retweetBackgroundView.width = kScreenWidth;
    [_containerView addSubview:_retweetBackgroundView];
    
    _contentTextLabel = [YYLabel new];
    _contentTextLabel.left = kWBCellPadding;
    _contentTextLabel.width = kWBCellContentWidth;
    _contentTextLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _contentTextLabel.displaysAsynchronously = YES;
    _contentTextLabel.ignoreCommonProperties = YES;
    _contentTextLabel.fadeOnAsynchronouslyDisplay = NO;
    _contentTextLabel.fadeOnHighlight = NO;
    _contentTextLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakself.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakself.delegate cell:weakself didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_containerView addSubview:_contentTextLabel];
    
    
    _retweetTextLabel = [YYLabel new];
    _retweetTextLabel.left = kWBCellPadding;
    _retweetTextLabel.width = kWBCellContentWidth;
    _retweetTextLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _retweetTextLabel.displaysAsynchronously = YES;
    _retweetTextLabel.ignoreCommonProperties = YES;
    _retweetTextLabel.fadeOnAsynchronouslyDisplay = NO;
    _retweetTextLabel.fadeOnHighlight = NO;
    _retweetTextLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakself.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakself.delegate cell:weakself didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_containerView addSubview:_retweetTextLabel];
}

- (void)setStatusM:(YWBStatus *)statusM {
    _statusM = statusM;
    self.contentView.height = statusM.cellHeight;
    _containerView.top = kWBCellTopMargin;
    _containerView.height = statusM.cellHeight - kWBCellTopMargin - kWBCellToolbarBottomMargin;
    CGFloat top = 0.;
    if (statusM.title.titleHeight > 1) {
        _titleView.hidden = NO;
        _titleView.titleM = statusM.title;
        top += statusM.title.titleHeight;
    } else {
        _titleView.hidden = YES;
    }
    
    _profileView.top = top;
    _profileView.userM = statusM.user;
    top += statusM.user.profileHeight;
    
    
    _contentTextLabel.top = top;
    _contentTextLabel.height = statusM.contentM.textHeight;
    _contentTextLabel.textLayout = statusM.contentM.textLayout;
    top += statusM.contentM.textHeight;
    
    _retweetBackgroundView.hidden = YES;
    _retweetTextLabel.hidden = YES;
    
    if (statusM.contentM.retweetHeight > 0.1) {
        _retweetBackgroundView.top = top;
        _retweetBackgroundView.height = statusM.contentM.retweetHeight;
        _retweetBackgroundView.hidden = NO;
        
        _retweetTextLabel.top = top;
        _retweetTextLabel.height = statusM.contentM.retweetTextHeight;
        _retweetTextLabel.textLayout = statusM.contentM.retweetTextLayout;
        _retweetTextLabel.hidden = NO;
    }
    
    _toolbarView.top = top;
    _toolbarView.toobarM = statusM.toobarM;
    top += statusM.toobarM.toolbarHeight;
}


@end
