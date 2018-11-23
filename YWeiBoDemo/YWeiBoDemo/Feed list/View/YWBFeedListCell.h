//
//  YWBFeedListCell.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWBModel.h"
#import "YWBStatusHelper.h"

NS_ASSUME_NONNULL_BEGIN
@class YWBFeedListCell;
@protocol YWBStatusCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(YWBFeedListCell *)cell;
/// 点击了 Card
- (void)cellDidClickCard:(YWBFeedListCell *)cell;
/// 点击了转发内容
- (void)cellDidClickRetweet:(YWBFeedListCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(YWBFeedListCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(YWBFeedListCell *)cell;
/// 点击了转发
- (void)cellDidClickRepost:(YWBFeedListCell *)cell;
/// 点击了下方 Tag
- (void)cellDidClickTag:(YWBFeedListCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(YWBFeedListCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(YWBFeedListCell *)cell;
/// 点击了用户
- (void)cell:(YWBFeedListCell *)cell didClickUser:(YWBUser *)user;
/// 点击了图片
- (void)cell:(YWBFeedListCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(YWBFeedListCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end

@interface YWBFeedListCell : UITableViewCell

@property (nonatomic, strong) YWBStatus *statusM;

@property (nonatomic, weak) id<YWBStatusCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
