//
//  YWBFeedListCell.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBFeedListCell.h"

#import "YWBStatusTitleView.h"
#import "YWBProfileView.h"
#import "YWBToolbarView.h"

@interface YWBFeedListCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) YWBProfileView *profileView;
@property (nonatomic, strong) YWBStatusTitleView *titleView;
@property (nonatomic, strong) YWBToolbarView *toolbarView;

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
    
    _toolbarView.top = top;
    _toolbarView.toobarM = statusM.toobarM;
    top += statusM.toobarM.toolbarHeight;
}


@end
