//
//  YWBProfileView.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBProfileView.h"
#import "YWBFeedListCell.h"
#import "YWBStatusHelper.h"

@implementation YWBProfileView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;

    _avatarView = [UIImageView new];
    _avatarView.size = CGSizeMake(40, 40);
    _avatarView.origin = CGPointMake(kWBCellPadding, kWBCellPadding + 3);
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_avatarView];
    
    CALayer *avatarBorder = [CALayer layer];
    avatarBorder.frame = _avatarView.bounds;
    avatarBorder.borderWidth = CGFloatFromPixel(1);
    avatarBorder.borderColor = [UIColor colorWithWhite:0.000 alpha:0.090].CGColor;
    avatarBorder.cornerRadius = _avatarView.height / 2;
    avatarBorder.shouldRasterize = YES;
    avatarBorder.rasterizationScale = kScreenScale;
    [_avatarView.layer addSublayer:avatarBorder];
    
    _avatarBadgeView = [UIImageView new];
    _avatarBadgeView.size = CGSizeMake(14, 14);
    _avatarBadgeView.center = CGPointMake(_avatarView.right - 6, _avatarView.bottom - 6);
    _avatarBadgeView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_avatarBadgeView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kWBCellNameWidth, 24);
    _nameLabel.left = _avatarView.right + kWBCellNamePaddingLeft;
    _nameLabel.centerY = 27;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.frame = _nameLabel.frame;
    _sourceLabel.centerY = 47;
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    kWeakSelf(self)
    _sourceLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakself.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakself.cell.delegate cell:weakself.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_sourceLabel];
    
    return self;
}

- (void)setUserM:(YWBUser *)userM {
    _userM = userM;
    /// 圆角头像
    [_avatarView setImageWithURL:userM.avatar_large //profileImageURL
                                 placeholder:nil
                                     options:kNilOptions
                                     manager:[YWBStatusHelper avatarImageManager] ///< 圆角头像manager，内置圆角处理
                                    progress:nil
                                   transform:nil
                                  completion:nil];
    
    switch (userM.userVerifyType) {
        case YWBUserVerifyTypeStandard: {
            _avatarBadgeView.hidden = NO;
            _avatarBadgeView.image = [YWBStatusHelper imageNamed:@"avatar_vip"];
        } break;
        case YWBUserVerifyTypeClub: {
            _avatarBadgeView.hidden = NO;
            _avatarBadgeView.image = [YWBStatusHelper imageNamed:@"avatar_grassroot"];
        } break;
        default: {
            _avatarBadgeView.hidden = YES;
        } break;
    }
    
    _nameLabel.textLayout = userM.nameTextLayout;
    _sourceLabel.textLayout = userM.sourceTextLayout;
}

@end
