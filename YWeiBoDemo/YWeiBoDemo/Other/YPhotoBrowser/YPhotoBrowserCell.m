//
//  YPhotoBrowserCell.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YPhotoBrowserCell.h"

@interface YPhotoBrowserCell ()<UIScrollViewDelegate>


@end

@implementation YPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _scrollView = [UIScrollView new];
        _scrollView.top = 0;
        _scrollView.left = kCellPadding / 2.0;
        _scrollView.width = self.width - kCellPadding;
        _scrollView.height = self.height;
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale =  0.5;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_scrollView];
        
        _imageContainerView = [UIView new];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.backgroundColor = [UIColor clearColor];
        
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [YYAnimatedImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        [_imageContainerView addSubview:_imageView];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.size = CGSizeMake(40, 40);
        _progressLayer.center = self.contentView.center;
        _progressLayer.cornerRadius = 20;
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 3;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.hidden = YES;
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)setPhotoM:(YPhotoBrowserModel *)photoM {
    _photoM = photoM;
    
    [_imageView cancelCurrentImageRequest];
    [_imageView.layer removePreviousFadeAnimation];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_photoM) {
        _imageView.image = nil;
        return;
    }
    
    kWeakSelf(self);
    [_imageView setImageWithURL:photoM.imageURL placeholder:photoM.placeholderImage
                    options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        kStrongSelf(self);
        if (!self) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;
    } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        kStrongSelf(self);
        if (!self) return;
        self.progressLayer.hidden = YES;
        if (stage == YYWebImageStageFinished) {
            self.scrollView.maximumZoomScale = 3;
            if (image) {
                [self resizeSubviewSize];
                [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }
        
    }];
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.scrollView.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.scrollView.height / self.scrollView.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.scrollView.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) height = self.scrollView.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.scrollView.height && _imageContainerView.height - self.scrollView.height <= 1) {
        _imageContainerView.height = self.scrollView.height;
    }
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, MAX(_imageContainerView.height, self.scrollView.height));
    [_scrollView scrollRectToVisible:self.scrollView.bounds animated:NO];
    
    if (_imageContainerView.height <= self.scrollView.height) {
        _scrollView.alwaysBounceVertical = NO;
    } else {
        _scrollView.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (CGFloat)zoomScale {
    return _scrollView.zoomScale;
}

- (CGFloat)maximumZoomScale {
    return _scrollView.maximumZoomScale;
}

- (void)scrollToTopAnimated:(BOOL)animated {
    [_scrollView scrollToTopAnimated:animated];
}

- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated {
    [_scrollView setZoomScale:scale animated:animated];
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    [_scrollView zoomToRect:rect animated:animated];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


@end
