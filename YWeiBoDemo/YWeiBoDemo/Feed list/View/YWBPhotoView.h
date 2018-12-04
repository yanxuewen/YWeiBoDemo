//
//  YWBPhotoView.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/4.
//  Copyright © 2018 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWBPhotoView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^touchBlock)(YWBPhotoView *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(YWBPhotoView *view, CGPoint point);

@end

NS_ASSUME_NONNULL_END
