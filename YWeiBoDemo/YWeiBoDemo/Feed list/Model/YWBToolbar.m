//
//  YWBToolbar.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/26.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBToolbar.h"
#import "YWBStatusHelper.h"
#import "YWBModel.h"

@implementation YWBToolbar

- (void)y_layout {
    // should be localized
    _toolbarHeight = kWBCellToolbarHeight;
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *repostText = [[NSMutableAttributedString alloc] initWithString:_status.reposts_count <= 0 ? @"转发" : [YWBToolbar shortedNumberDesc:_status.reposts_count]];
    repostText.font = font;
    repostText.color = kWBCellToolbarTitleColor;
    _toolbarRepostTextLayout = [YYTextLayout layoutWithContainer:container text:repostText];
    _toolbarRepostTextWidth = CGFloatPixelRound(_toolbarRepostTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:_status.comments_count <= 0 ? @"评论" : [YWBToolbar shortedNumberDesc:_status.comments_count]];
    commentText.font = font;
    commentText.color = kWBCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:_status.attitudes_count <= 0 ? @"赞" : [YWBToolbar shortedNumberDesc:_status.attitudes_count]];
    likeText.font = font;
    likeText.color = _status.attitudes_status ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    _toolbarLikeTextWidth = CGFloatPixelRound(_toolbarLikeTextLayout.textBoundingRect.size.width);
}

+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    // should be localized
    if (number <= 9999) return [NSString stringWithFormat:@"%d", (int)number];
    if (number <= 9999999) return [NSString stringWithFormat:@"%d万", (int)(number / 10000)];
    return [NSString stringWithFormat:@"%d千万", (int)(number / 10000000)];
}

@end
