//
//  YWBToolbarView.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/26.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBToolbarView.h"
#import "YWBStatusHelper.h"
#import "YWBFeedListCell.h"
#import "YWBModel.h"

@implementation YWBToolbarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellToolbarHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _repostButton.exclusiveTouch = YES;
    _repostButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    [_repostButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    _commentButton.left = CGFloatPixelRound(self.width / 3.0);
    [_commentButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.exclusiveTouch = YES;
    _likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    _likeButton.left = CGFloatPixelRound(self.width / 3.0 * 2.0);
    [_likeButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _repostImageView = [[UIImageView alloc] initWithImage:[YWBStatusHelper imageNamed:@"timeline_icon_retweet"]];
    _repostImageView.centerY = self.height / 2;
    [_repostButton addSubview:_repostImageView];
    _commentImageView = [[UIImageView alloc] initWithImage:[YWBStatusHelper imageNamed:@"timeline_icon_comment"]];
    _commentImageView.centerY = self.height / 2;
    [_commentButton addSubview:_commentImageView];
    _likeImageView = [[UIImageView alloc] initWithImage:[YWBStatusHelper imageNamed:@"timeline_icon_unlike"]];
    _likeImageView.centerY = self.height / 2;
    [_likeButton addSubview:_likeImageView];
    
    _repostLabel = [YYLabel new];
    _repostLabel.userInteractionEnabled = NO;
    _repostLabel.height = self.height;
    _repostLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _repostLabel.displaysAsynchronously = YES;
    _repostLabel.ignoreCommonProperties = YES;
    _repostLabel.fadeOnHighlight = NO;
    _repostLabel.fadeOnAsynchronouslyDisplay = NO;
    [_repostButton addSubview:_repostLabel];
    
    _commentLabel = [YYLabel new];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.height = self.height;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _commentLabel.displaysAsynchronously = YES;
    _commentLabel.ignoreCommonProperties = YES;
    _commentLabel.fadeOnHighlight = NO;
    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
    [_commentButton addSubview:_commentLabel];
    
    _likeLabel = [YYLabel new];
    _likeLabel.userInteractionEnabled = NO;
    _likeLabel.height = self.height;
    _likeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _likeLabel.displaysAsynchronously = YES;
    _likeLabel.ignoreCommonProperties = YES;
    _likeLabel.fadeOnHighlight = NO;
    _likeLabel.fadeOnAsynchronouslyDisplay = NO;
    [_likeButton addSubview:_likeLabel];
    
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.2, @0.5, @0.8];
    
    _line1 = [CAGradientLayer layer];
    _line1.colors = colors;
    _line1.locations = locations;
    _line1.startPoint = CGPointMake(0, 0);
    _line1.endPoint = CGPointMake(0, 1);
    _line1.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line1.left = _repostButton.right;
    
    _line2 = [CAGradientLayer layer];
    _line2.colors = colors;
    _line2.locations = locations;
    _line2.startPoint = CGPointMake(0, 0);
    _line2.endPoint = CGPointMake(0, 1);
    _line2.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line2.left = _commentButton.right;
    
    _topLine = [CALayer layer];
    _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    _topLine.backgroundColor = kWBCellLineColor.CGColor;
    
    _bottomLine = [CALayer layer];
    _bottomLine.size = _topLine.size;
    _bottomLine.bottom = self.height;
    _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
    
    [self addSubview:_repostButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self.layer addSublayer:_line1];
    [self.layer addSublayer:_line2];
    [self.layer addSublayer:_topLine];
    [self.layer addSublayer:_bottomLine];
    
    kWeakSelf(self)
    [_repostButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        YWBFeedListCell *cell = weakself.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickRepost:)]) {
            [cell.delegate cellDidClickRepost:cell];
        }
    }];
    
    [_commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        YWBFeedListCell *cell = weakself.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
            [cell.delegate cellDidClickComment:cell];
        }
    }];
    
    [_likeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        YWBFeedListCell *cell = weakself.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
            [cell.delegate cellDidClickLike:cell];
        }
    }];
    return self;
}


- (void)setToobarM:(YWBToolbar *)toobarM {
    _toobarM = toobarM;
    _repostLabel.width = toobarM.toolbarRepostTextWidth;
    _commentLabel.width = toobarM.toolbarCommentTextWidth;
    _likeLabel.width = toobarM.toolbarLikeTextWidth;
    
    _repostLabel.textLayout = toobarM.toolbarRepostTextLayout;
    _commentLabel.textLayout = toobarM.toolbarCommentTextLayout;
    _likeLabel.textLayout = toobarM.toolbarLikeTextLayout;
    
    [self adjustImage:_repostImageView label:_repostLabel inButton:_repostButton];
    [self adjustImage:_commentImageView label:_commentLabel inButton:_commentButton];
    [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
    
    _likeImageView.image = toobarM.status.attitudes_status ? [self likeImage] : [self unlikeImage];
    
}


- (UIImage *)likeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [YWBStatusHelper imageNamed:@"timeline_icon_like"];
    });
    return img;
}

- (UIImage *)unlikeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [YWBStatusHelper imageNamed:@"timeline_icon_unlike"];
    });
    return img;
}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {
    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
    image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2);
    label.right = CGFloatPixelRound(button.width - paddingSide);
}

- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation {
    
    if (_toobarM.status.attitudes_status == liked) return;
    
    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
    NSInteger newCount = _toobarM.status.attitudes_count;
    newCount = liked ? newCount + 1 : newCount - 1;
    if (newCount < 0) newCount = 0;
    if (liked && newCount < 1) newCount = 1;
    NSString *newCountDesc = newCount > 0 ? [YWBToolbar shortedNumberDesc:newCount] : @"赞";
    
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:newCountDesc];
    likeText.font = font;
    likeText.color = liked ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    
    _toobarM.status.attitudes_status = liked;
    _toobarM.status.attitudes_status = newCount;
    _toobarM.toolbarLikeTextLayout = textLayout;
    
    if (!animation) {
        _likeImageView.image = image;
        _likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
        _likeLabel.textLayout = _toobarM.toolbarLikeTextLayout;
        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
        return;
    }
    
    kWeakSelf(self)
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.likeImageView.layer.transformScale = 1.7;
    } completion:^(BOOL finished) {
        
        weakself.likeImageView.image = image;
        weakself.likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
        weakself.likeLabel.textLayout = weakself.toobarM.toolbarLikeTextLayout;
        [self adjustImage:weakself.likeImageView label:weakself.likeLabel inButton:weakself.likeButton];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            weakself.likeImageView.layer.transformScale = 0.9;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                weakself.likeImageView.layer.transformScale = 1;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

@end
