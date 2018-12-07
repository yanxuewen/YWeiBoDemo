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

@property (nonatomic, assign) NSInteger fromIndex;
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;

@end

@implementation YPhotoBrowser

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)viewDidLoad {
//    NSLog(@"%s",__func__);
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    [self setupGestureRecognizer];
    [self setupUI];
    _fromIndex = _currentIndex;
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr.copy;
    [_collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_isPresented && _currentIndex != _fromIndex) {
        _fromIndex = _currentIndex;
        
        UIView *fromView = _picViews[_currentIndex];
        fromView.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        self.snapshorImageHideFromView = [self.toContainerView snapshotImage];
        self.background.image = self.snapshorImageHideFromView;
        fromView.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
    }
}

- (void)setupUI {
    _background = [UIImageView new];
    _background.frame = self.view.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_background];
    
    _blackBackground = [UIView new];
    _blackBackground.frame = self.view.bounds;
    _blackBackground.backgroundColor = [UIColor blackColor];
    _blackBackground.alpha = 0;
    [self.view addSubview:_blackBackground];
    
    _itemWidth = self.view.width + kCellPadding;
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(_itemWidth, self.view.height);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.width = _itemWidth;
    _collectionView.left = -kCellPadding/2.0;
    _collectionView.backgroundColor = [UIColor clearColor];
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
//    [self dismissAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tapG {
    if (!_isPresented) return;
    YPhotoBrowserCell *cell = _collectionView.visibleCells.firstObject;;
    if (cell) {
        if (cell.zoomScale > 1) {
            [cell setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [tapG locationInView:cell.imageView];
            CGFloat newZoomScale = cell.maximumZoomScale;
            CGFloat xsize = self.view.width / newZoomScale;
            CGFloat ysize = self.view.height / newZoomScale;
            [cell zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)panG {
    switch (panG.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [panG locationInView:self.view];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            
            YPhotoBrowserCell *cell =_collectionView.visibleCells.firstObject;
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [panG locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            CGFloat deltaX = p.x - _panGestureBeginPoint.x;
            cell.scrollView.top = deltaY;
            cell.scrollView.left = deltaX + kCellPadding/2.0;
            
            CGFloat scale = self.fromView.width / self.view.width;
            CGFloat alphaDelta = 240;
            if (fabs(deltaY) > alphaDelta) {
                scale = (1.0 - scale) / 2.0 + scale;
            } else {
                scale = 1.0 -  fabs(deltaY) / alphaDelta * (1.0 - scale) / 2.0;
            }
            cell.scrollView.zoomScale = scale;
            
            CGFloat alpha = 1.0;
            if (fabs(deltaY) > alphaDelta) {
                alpha = 0.3;
            } else {
                alpha = 1.0 -  fabs(deltaY) / alphaDelta * 0.7;
            }
           
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                self.blackBackground.alpha = alpha;
                self.pageControl.alpha = alpha;
                
            } completion:^(BOOL finished) {
                
            }];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [panG velocityInView:self.view];
            CGPoint p = [panG locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
//            CGFloat deltaX = p.x - _panGestureBeginPoint.x;
            YPhotoBrowserCell *cell =_collectionView.visibleCells.firstObject;
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                
                cell.scrollView.clipsToBounds = NO;
                [self dismissViewControllerAnimated:YES completion:nil];
             
            } else {
                
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//                    self.collectionView.top = 0;
//                    self.collectionView.left = -kCellPadding/2.0;
                    cell.scrollView.top = 0;
                    cell.scrollView.left = kCellPadding/2.0;
                    self.blackBackground.alpha = 1;
                    self.pageControl.alpha = 1;
                    cell.scrollView.zoomScale = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            _collectionView.top = 0;
            _blackBackground.alpha = 1;
        }
        default:break;
    }
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
        self.currentIndex = intPage;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat floatPage = scrollView.contentOffset.x / _itemWidth;
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _imageArr.count ? (int)_imageArr.count - 1 : intPage;
    _pageControl.currentPage = intPage;
    self.currentIndex = intPage;
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (page >= 0 && page < _imageArr.count ) {
        CGFloat offsetX = _itemWidth * page;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
