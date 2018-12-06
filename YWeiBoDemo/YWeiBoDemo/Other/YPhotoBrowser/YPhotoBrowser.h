//
//  YPhotoBrowser.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YPhotoBrowserModel;
@interface YPhotoBrowser : UIViewController

@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) NSArray *picViews;
@property (nonatomic, strong) UIView *toContainerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;
@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;
@property (nonatomic, assign) BOOL isPresented;

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
- (void)cancelAllImageLoad;

@end

NS_ASSUME_NONNULL_END
