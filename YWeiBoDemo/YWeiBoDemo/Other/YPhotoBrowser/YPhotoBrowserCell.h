//
//  YPhotoBrowserCell.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPhotoBrowserModel.h"

#define kCellPadding 20

NS_ASSUME_NONNULL_BEGIN

@interface YPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) YPhotoBrowserModel *photoM;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

NS_ASSUME_NONNULL_END
