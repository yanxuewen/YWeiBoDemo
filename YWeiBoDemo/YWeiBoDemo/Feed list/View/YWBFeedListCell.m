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
#import "YWBCardView.h"
#import "YWBTagView.h"

@interface YWBFeedListCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) YWBProfileView *profileView;
@property (nonatomic, strong) UIImageView *vipBackgroundView;
@property (nonatomic, strong) YWBStatusTitleView *titleView;
@property (nonatomic, strong) YWBToolbarView *toolbarView;
@property (nonatomic, strong) YWBCardView *cardView;
@property (nonatomic, strong) YWBTagView *tagView;

@property (nonatomic, strong) YYLabel *contentTextLabel;        // 文本
@property (nonatomic, strong) NSArray<UIImageView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    // 转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本

@property (nonatomic, assign) BOOL touchRetweetView;

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
    
    _vipBackgroundView = [UIImageView new];
    _vipBackgroundView.size = CGSizeMake(kScreenWidth, 14.0);
//    _vipBackgroundView.top = -2;
    _vipBackgroundView.contentMode = UIViewContentModeTopRight;
    [_containerView addSubview:_vipBackgroundView];
    
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
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = kWBCellHighlightColor;
        imageView.exclusiveTouch = YES;
        
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) {
                [weakself.delegate cell:weakself didClickImageAtIndex:i];
            }
        }]];
        
        UIView *badge = [UIImageView new];
        badge.userInteractionEnabled = NO;
        badge.contentMode = UIViewContentModeScaleAspectFit;
        badge.size = CGSizeMake(56 / 2, 36 / 2);
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.right = imageView.width;
        badge.bottom = imageView.height;
        badge.hidden = YES;
        [imageView addSubview:badge];
        
        [picViews addObject:imageView];
        [_containerView addSubview:imageView];
    }
    _picViews = picViews;
    
    _cardView = [YWBCardView new];
    _cardView.hidden = YES;
    _cardView.cell = self;
    [_containerView addSubview:_cardView];
    
    _tagView = [YWBTagView new];
    _tagView.hidden = YES;
    _tagView.cell = self;
    [_containerView addSubview:_tagView];
    
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
    
    NSURL *picBg = [YWBStatusHelper defaultURLForImageURL:statusM.pic_bg];
    if (picBg) {
        [_vipBackgroundView setImageWithURL:picBg options:YYWebImageOptionSetImageWithFadeAnimation];
    } else {
        _vipBackgroundView.image = nil;
    }
    
    _contentTextLabel.top = top;
    _contentTextLabel.height = statusM.contentM.textHeight;
    _contentTextLabel.textLayout = statusM.contentM.textLayout;
    top += statusM.contentM.textHeight;
    
    _retweetBackgroundView.hidden = YES;
    _retweetTextLabel.hidden = YES;
    _cardView.hidden = YES;
    if (statusM.contentM.picHeight == 0 && statusM.contentM.retweetPicHeight == 0) {
        [self y_hideImageViews];
    }
    
    if (statusM.contentM.retweetHeight > 0.1) {
        _retweetBackgroundView.top = top;
        _retweetBackgroundView.height = statusM.contentM.retweetHeight;
        _retweetBackgroundView.hidden = NO;
        
        _retweetTextLabel.top = top;
        _retweetTextLabel.height = statusM.contentM.retweetTextHeight;
        _retweetTextLabel.textLayout = statusM.contentM.retweetTextLayout;
        _retweetTextLabel.hidden = NO;
        
        if (statusM.contentM.retweetPicHeight > 0.1) {
            [self y_setImageViewWithTop:_retweetTextLabel.bottom isRetweet:YES];
        } else {
            [self y_hideImageViews];
            if (statusM.contentM.retweetCardHeight > 0.1) {
                _cardView.top = _retweetTextLabel.bottom;
                _cardView.hidden = NO;
                [_cardView setStatus:statusM isRetweet:YES];
            }
        }
        top += statusM.contentM.retweetHeight;
        
    } else if (statusM.contentM.picHeight > 0) {
        [self y_setImageViewWithTop:top isRetweet:NO];
        top += statusM.contentM.picHeight;
        
    } else if (statusM.contentM.cardHeight > 0) {
        _cardView.top = top;
        _cardView.hidden = NO;
        [_cardView setStatus:statusM isRetweet:NO];
        top += statusM.contentM.cardHeight + kWBCellPadding;
    }
    
    if (statusM.tag_struct.firstObject.tagHeight > 0.1) {
        _tagView.hidden = NO;
        [_tagView setTagM:statusM.tag_struct.firstObject];
//        _tagView.centerY = _containerView.height - kWBCellToolbarHeight - _tagView.tagM.tagHeight / 2;
        _tagView.top = top;
        top += _tagView.tagM.tagHeight;
    } else {
        _tagView.hidden = YES;
    }
    
    _toolbarView.top = top;
    _toolbarView.toobarM = statusM.toobarM;
    top += statusM.toobarM.toolbarHeight;
}

- (void)y_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)y_setImageViewWithTop:(CGFloat)imageTop isRetweet:(BOOL)isRetweet {
    CGSize picSize = isRetweet ? _statusM.contentM.retweetPicSize : _statusM.contentM.picSize;
    NSArray *pics = isRetweet ? _statusM.retweeted_status.pics : _statusM.pics;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kWBCellPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kWBCellPadding + (i % 2) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kWBCellPaddingPic);
                } break;
                default: {
                    origin.x = kWBCellPadding + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            
            YWBPicInfo *pic = pics[i];
            
            UIView *badge = imageView.subviews.firstObject;
            switch (pic.largest.badgeType) {
                case YWBPicBadgeTypeNone: {
                    if (badge.layer.contents) {
                        badge.layer.contents = nil;
                        badge.hidden = YES;
                    }
                } break;
                case YWBPicBadgeTypeLong: {
                    badge.layer.contents = (__bridge id)([YWBStatusHelper imageNamed:@"timeline_image_longimage"].CGImage);
                    badge.hidden = NO;
                } break;
                case YWBPicBadgeTypeGIF: {
                    badge.layer.contents = (__bridge id)([YWBStatusHelper imageNamed:@"timeline_image_gif"].CGImage);
                    badge.hidden = NO;
                } break;
            }
            
            kWeakSelf(imageView);
            [imageView setImageWithURL:pic.bmiddle.url
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      kStrongSelf(imageView);

                                      if (!imageView) return;
                                      if (image && stage == YYWebImageStageFinished) {
                                          NSInteger width = pic.bmiddle.width;
                                          NSInteger height = pic.bmiddle.height;
                                          CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                          if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                              imageView.contentMode = UIViewContentModeScaleAspectFit;
                                              
                                          } else { // 高图只保留顶部
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                             
                                          }
                                          if (from != YYWebImageFromMemoryCache) {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                              transition.type = kCATransitionFade;
                                              [imageView.layer addAnimation:transition forKey:@"YYWebImageFade"];
                                          }

                                          imageView.image = image;

                                      }
                                  }];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:_retweetBackgroundView];
    BOOL insideRetweet = CGRectContainsPoint(_retweetBackgroundView.bounds, p);
    
    if (!_retweetBackgroundView.hidden && insideRetweet) {
        [(_retweetBackgroundView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = YES;
    } else {
        [(_containerView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    if (_touchRetweetView) {
        if ([_delegate respondsToSelector:@selector(cellDidClickRetweet:)]) {
            [_delegate cellDidClickRetweet:self];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(cellDidClick:)]) {
            [_delegate cellDidClick:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_retweetBackgroundView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    [NSObject cancelPreviousPerformRequestsWithTarget:_containerView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    
    _containerView.backgroundColor = [UIColor whiteColor];
    _retweetBackgroundView.backgroundColor = kWBCellInnerViewColor;
}

@end
