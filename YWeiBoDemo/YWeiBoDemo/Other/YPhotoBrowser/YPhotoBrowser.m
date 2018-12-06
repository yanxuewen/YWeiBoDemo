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

@end

@implementation YPhotoBrowser

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


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
//    [self dismissAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
