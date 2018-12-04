//
//  YPhotoBrowserModel.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YWBPhotoView;

@interface YPhotoBrowserModel : YBaseModel

@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, strong, readonly) UIImage *placeholderImage;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign, readonly) BOOL placeholderClippedToTop;

@end

NS_ASSUME_NONNULL_END
