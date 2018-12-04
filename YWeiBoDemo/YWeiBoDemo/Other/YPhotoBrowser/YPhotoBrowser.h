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

//- (instancetype)initWithImageArr:(NSArray<YPhotoBrowserModel *> *)imageArr;
//- (instancetype)initWithImageArr:(NSArray<YPhotoBrowserModel *> *)imageArr index:(NSInteger)index;

- (void)presentFromImageView:(UIView *)fromView toContainer:(UIView *)toContainer animated:(BOOL)animated completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
