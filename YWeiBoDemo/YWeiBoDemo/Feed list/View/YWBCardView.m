//
//  YWBCardView.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBCardView.h"
#import "YWBStatusHelper.h"
#import "YWBFeedListCell.h"
#import "YWBModel.h"

@implementation YWBCardView{
    BOOL _isRetweet;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0){
        frame.size.width = kScreenWidth;
        frame.origin.x = kWBCellPadding;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _badgeImageView = [UIImageView new];
    _badgeImageView.clipsToBounds = YES;
    _badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    _label = [YYLabel new];
    _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _label.numberOfLines = 3;
    _label.ignoreCommonProperties = YES;
    _label.displaysAsynchronously = YES;
    _label.fadeOnAsynchronouslyDisplay = NO;
    _label.fadeOnHighlight = NO;
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_imageView];
    [self addSubview:_badgeImageView];
    [self addSubview:_label];
    [self addSubview:_button];
    self.backgroundColor = kWBCellInnerViewColor;
    self.layer.borderWidth = CGFloatFromPixel(1);
    self.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.070].CGColor;
    return self;
}


- (void)setStatus:(YWBStatus *)status isRetweet:(BOOL)isRetweet {
    YWBPageInfo *pageInfo = isRetweet ? status.retweeted_status.page_info : status.page_info;
    if (!pageInfo) return;
    self.height = isRetweet ? status.contentM.retweetCardHeight : status.contentM.cardHeight;
    
    /*
     badge: 25,25 左上角 (42)
     image: 70,70 方形
     100, 70 矩形
     btn:  60,70
     
     lineheight 20
     padding 10
     */
    
    _isRetweet = isRetweet;
    switch (isRetweet ? status.contentM.retweetCardType : status.contentM.cardType) {
        case YWBStatusCardTypeNone: {
            
        } break;
        case YWBStatusCardTypeNormal: {
            self.width = kWBCellContentWidth;
            if (pageInfo.type_icon) {
                _badgeImageView.hidden = NO;
                _badgeImageView.frame = CGRectMake(0, 0, 25, 25);
                [_badgeImageView setImageWithURL:pageInfo.type_icon placeholder:nil];
            } else {
                _badgeImageView.hidden = YES;
            }
            if (pageInfo.page_pic) {
                _imageView.hidden = NO;
                if (pageInfo.type_icon) {
                    _imageView.frame = CGRectMake(0, 0, 100, 70);
                } else {
                    _imageView.frame = CGRectMake(0, 0, 70, 70);
                }
                [_imageView setImageWithURL:pageInfo.page_pic placeholder:nil];
            } else {
                _imageView.hidden = YES;
            }
            _label.hidden = NO;
            _label.frame = isRetweet ? status.contentM.retweetCardTextRect : status.contentM.cardTextRect;
            _label.textLayout = isRetweet ? status.contentM.retweetCardTextLayout : status.contentM.cardTextLayout;
            YWBButtonLink *button = pageInfo.buttons.firstObject;
            if (button.pic && button.name) {
                _button.hidden = NO;
                _button.size = CGSizeMake(60, 70);
                _button.top = 0;
                _button.right = self.width;
                [_button setTitle:button.name forState:UIControlStateNormal];
                [_button setImageWithURL:button.pic forState:UIControlStateNormal placeholder:nil];
            } else {
                _button.hidden = YES;
            }
        }break;
        case YWBStatusCardTypeVideo: {
            self.width = self.height;
            _badgeImageView.hidden = YES;
            _label.hidden = YES;
            _imageView.frame = self.bounds;
            [_imageView setImageWithURL:pageInfo.page_pic options:kNilOptions];
            _button.hidden = NO;
            _button.frame = self.bounds;
            [_button setTitle:nil forState:UIControlStateNormal];
            [_button cancelImageRequestForState:UIControlStateNormal];
            [_button setImage:[YWBStatusHelper imageNamed:@"multimedia_videocard_play"] forState:UIControlStateNormal];
            
        } break;
        default: {
            
        } break;
    }
    
    self.backgroundColor = isRetweet ? [UIColor whiteColor] : kWBCellInnerViewColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = kWBCellInnerViewHighlightColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = _isRetweet ? [UIColor whiteColor] : kWBCellInnerViewColor;
    if ([_cell.delegate respondsToSelector:@selector(cellDidClickCard:)]) {
        [_cell.delegate cellDidClickCard:_cell];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = _isRetweet ? [UIColor whiteColor] : kWBCellInnerViewColor;
}


@end
