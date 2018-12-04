//
//  YPhotoBrowserModel.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/12/3.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YPhotoBrowserModel.h"

@implementation YPhotoBrowserModel

- (UIImage *)placeholderImage {
    if ([_placeholderView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_placeholderView).image;
    }
    return nil;
}

- (BOOL)placeholderClippedToTop {
    if (_placeholderView) {
        if (_placeholderView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

@end
