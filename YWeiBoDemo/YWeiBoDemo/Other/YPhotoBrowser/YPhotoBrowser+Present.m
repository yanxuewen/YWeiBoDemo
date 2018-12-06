//
//  YPhotoBrowser+Present.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/6.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YPhotoBrowser+Present.h"
#import "YPhotoBrowserCell.h"

@implementation YPhotoBrowser (Present)

- (instancetype)init {
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (fromView != nil) {
        [self dismissAnimate:transitionContext];
        return;
    }
    
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    self.snapshorImageHideFromView = [self.toContainerView snapshotImage];
    
    self.background.image = self.snapshorImageHideFromView;
    self.blurBackground.image = [self.snapshorImageHideFromView imageByBlurDark];
    
    self.view.size = self.toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pageControl.alpha = 0;
    self.pageControl.numberOfPages = self.imageArr.count;
    self.pageControl.currentPage = self.currentIndex;
    
    [self scrollToPage:self.currentIndex animated:NO];
    
    
    UIView *containView = [transitionContext containerView];
    
    YPhotoBrowserModel *model = self.imageArr[self.currentIndex];
    
    YPhotoBrowserCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[YPhotoBrowserCell className] forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.imageView.image = model.placeholderImage;
    cell.alpha = 0;
    cell.left = -kCellPadding/2.0;      /// cell 宽度比屏幕宽 kCellPadding
    [cell resizeSubviewSize];
    
    [self.view addSubview:cell];
    [containView addSubview:self.view];
    if (model.placeholderClippedToTop) {
        CGRect fromFrame = [self.fromView convertRect:self.fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
       
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.height = fromFrame.size.height / scale;
        cell.imageContainerView.layer.transformScale = scale;
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        
        float oneTime = 0.25;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blurBackground.alpha = 1;
        }completion:NULL];
        
        self.view.userInteractionEnabled = NO;
        self.collectionView.alpha = 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageContainerView.layer.transformScale = 1;
            cell.imageContainerView.frame = originFrame;
            cell.alpha = 1;
            self.pageControl.alpha = 1;
            
        }completion:^(BOOL finished) {
            self.isPresented = YES;
            cell.hidden = YES;
            [cell removeFromSuperview];
            self.collectionView.alpha = 1;
            self.fromView.hidden = fromViewHidden;
            self.view.userInteractionEnabled = YES;
            self.toContainerView.userInteractionEnabled = YES;
            [transitionContext completeTransition:finished];
        }];
        
    } else {
        CGRect fromFrame = [self.fromView convertRect:self.fromView.bounds toView:cell.imageContainerView];
        
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = 0.25;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blurBackground.alpha = 1;
        }completion:NULL];
        
        self.view.userInteractionEnabled = NO;
        self.collectionView.alpha = 0;
        
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            cell.imageView.layer.transformScale = 1.;
            cell.alpha = 1;
            
        }completion:^(BOOL finished) {
            self.pageControl.alpha = 1;
            cell.imageContainerView.clipsToBounds = YES;
            self.isPresented = YES;
            cell.hidden = YES;
            [cell removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            self.collectionView.alpha = 1;
            self.fromView.hidden = fromViewHidden;
            self.toContainerView.userInteractionEnabled = YES;
            [transitionContext completeTransition:finished];
            
        }];
    }
    
}

- (void)dismissAnimate:(id<UIViewControllerContextTransitioning>)transitionContext {
    [UIView setAnimationsEnabled:YES];
   
    NSInteger currentPage = self.currentIndex;
    YPhotoBrowserCell *cell = (YPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
//    YPhotoBrowserModel *item = self.imageArr[currentPage];
    
    UIView *fromView = self.picViews[self.currentIndex];
    
    
    [self cancelAllImageLoad];
    self.isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    self.toContainerView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.pageControl.alpha = 0.0;
        self.blurBackground.alpha = 0.0;
        
        if (isFromImageClipped) {
            
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            fromFrame.origin.x -= kCellPadding/2.0;
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
            if (isnan(height)) height = cell.imageContainerView.height;
            
            cell.imageContainerView.height = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            cell.imageContainerView.layer.transformScale = scale;
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
        
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self.view removeFromSuperview];
            self.toContainerView.userInteractionEnabled = YES;
            [transitionContext completeTransition:finished];
        }];
    }];
    
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

@end
