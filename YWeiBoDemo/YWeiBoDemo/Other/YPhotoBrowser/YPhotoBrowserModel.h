//
//  YPhotoBrowserModel.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPhotoBrowserModel : YBaseModel

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSURL *imageURL;

@end

NS_ASSUME_NONNULL_END
