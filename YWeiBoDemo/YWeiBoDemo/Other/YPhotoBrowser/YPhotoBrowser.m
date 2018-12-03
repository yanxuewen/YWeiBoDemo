//
//  YPhotoBrowser.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YPhotoBrowser.h"
#import "YPhotoBrowserCell.h"



@interface YPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger fromIndex;
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIImageView *fromView;
@property (nonatomic, strong) UIView *toContainerView;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;
@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;
@property (nonatomic, assign) BOOL isPresented;

@end

@implementation YPhotoBrowser

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor clearColor];
//        self.clipsToBounds = YES;
//
//        [self setupGestureRecognizer];
//        [self setupUI];
//    }
//    return self;
//}

- (void)viewDidLoad {
    NSLog(@"%s",__func__);
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
    [self setupGestureRecognizer];
    [self setupUI];
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr.copy;
    [_collectionView reloadData];
}

- (instancetype)initWithImageArr:(NSArray<YPhotoBrowserModel *> *)imageArr {
    if (self = [self init]) {
       
        self.imageArr = imageArr;
    }
    return self;
}

- (instancetype)initWithImageArr:(NSArray<YPhotoBrowserModel *> *)imageArr index:(NSInteger)index {
    self = [self initWithImageArr:imageArr];
    if (index > 0 && index < imageArr.count) {
        self.currentIndex = index;
    }
    
    return self;
}

- (void)setupUI {
    _background = [UIImageView new];
    _background.frame = self.view.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_background];
    
    _blurBackground = [UIImageView new];
    _blurBackground.frame = self.view.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_blurBackground];
    
    _itemWidth = self.view.width + kCellPadding;
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(_itemWidth, self.view.height);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.width = _itemWidth;
    _collectionView.left = -kCellPadding/2.0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delaysContentTouches = NO;
    _collectionView.canCancelContentTouches = YES;
    [_collectionView registerClass:[YPhotoBrowserCell class] forCellWithReuseIdentifier:[YPhotoBrowserCell className]];
    [self.view addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.width = self.view.width - 36;
    _pageControl.height = 10;
    _pageControl.center = CGPointMake(self.view.width / 2, self.view.height - 18);
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_pageControl];
    
    
}

#pragma mark - 手势
- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self.view addGestureRecognizer:tap2];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    _panGesture = pan;
}

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tapG {
    
}

- (void)pan:(UIPanGestureRecognizer *)panG {
    
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YPhotoBrowserCell className] forIndexPath:indexPath];
    cell.photoM = _imageArr[indexPath.row];
    return cell;
}


- (void)presentFromImageView:(UIImageView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(nullable void (^)(void))completion {
    if (!toContainer) return;
    
    _fromView = fromView;
    _toContainerView = toContainer;
    
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
//    _background.image = _snapshorImageHideFromView;
    _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark];
    
    self.view.size = _toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pageControl.alpha = 0;
    self.pageControl.numberOfPages = self.imageArr.count;
    self.pageControl.currentPage = self.currentIndex;
    [_toContainerView addSubview:self.view];
    
    [self scrollToPage:_currentIndex animated:NO];
    
//    [UIView setAnimationsEnabled:YES];
    
    YPhotoBrowserModel *model = _imageArr[_currentIndex];
    UIImageView *cell = [[UIImageView alloc] initWithFrame:self.view.bounds];
    cell.alpha = 0;
    cell.image = model.placeholderImage;
    cell.contentMode = UIViewContentModeScaleAspectFit;
//    cell.height = model.imageSize.height;
    [self.view addSubview:cell];
    
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
    CGRect originFrame = cell.frame;
    CGFloat scale = fromFrame.size.width / cell.width;
    
    cell.centerX = CGRectGetMidX(fromFrame);
    cell.height = fromFrame.size.height / scale;
    cell.layer.transformScale = scale;
    cell.centerY = CGRectGetMidY(fromFrame);
    
    float oneTime = animated ? 0.25 : 0;
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blurBackground.alpha = 1;
    }completion:NULL];
    
    self.collectionView.userInteractionEnabled = NO;
    self.collectionView.alpha = 0;
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.layer.transformScale = 1;
        cell.frame = originFrame;
        cell.alpha = 1;
        self.pageControl.alpha = 1;
        
    }completion:^(BOOL finished) {
        cell.hidden = YES;
        [cell removeFromSuperview];
        self.isPresented = YES;
        self.collectionView.userInteractionEnabled = YES;
        self.collectionView.alpha = 1;
        if (completion) completion();
    }];
    
    
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    NSInteger currentPage = self.currentIndex;
    YPhotoBrowserCell *cell = (YPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
    YPhotoBrowserModel *item = _imageArr[currentPage];
    
    UIImageView *fromView = nil;
    if (_fromIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView.image = item.placeholderImage;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
   
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    if (_fromIndex != currentPage) {
        _background.image = _snapshotImage;
        [_background.layer addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut];
    } else {
        _background.image = _snapshorImageHideFromView;
    }
    

    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.pageControl.alpha = 0.0;
        self.blurBackground.alpha = 0.0;
        
        CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.contentMode = fromView.contentMode;
        cell.imageView.frame = fromFrame;
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self.view removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)cancelAllImageLoad {
    NSArray *cells = [_collectionView visibleCells];
    [cells enumerateObjectsUsingBlock:^(YPhotoBrowserCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView cancelCurrentImageRequest];
    }];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat floatPage = scrollView.contentOffset.x / _itemWidth;
        NSInteger intPage = floatPage + 0.5;
        intPage = intPage < 0 ? 0 : intPage >= _imageArr.count ? _imageArr.count - 1 : intPage;
        _pageControl.currentPage = intPage;
        _currentIndex = intPage;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat floatPage = scrollView.contentOffset.x / _itemWidth;
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _imageArr.count ? (int)_imageArr.count - 1 : intPage;
    _pageControl.currentPage = intPage;
    _currentIndex = intPage;
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated{
    if (page >= 0 && page < _imageArr.count ) {
        CGFloat offsetX = _itemWidth * page;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    }
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
