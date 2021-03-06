//
//  YWBModel.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBModel.h"
#import "YWBStatusTitle.h"
#import "YWBStatusHelper.h"
#import "YWBUser.h"

@implementation YWBModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"ad" : [YWBAdModel class],
             @"advertises" : [NSString class],
             @"statuses" : [YWBStatus class],
             @"pics" : [YWBPicInfo class]
             };
}

@end


#pragma mark - YWBAdModel
@implementation YWBAdModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"id"};
}

@end

#pragma mark - YWBStatus
@implementation YWBStatus {
    CGFloat _cellHeight;
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"pics",@"toobarM",@"contentM"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"id",
             @"idNum" : @"id"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"url_struct" : [YWBURLStruct class],
             @"topic_struct" : [YWBTopicStruct class],
             @"tag_struct" : [YWBTagStruct class],
             @"page_info" : [YWBPageInfo class],
             @"title" : [YWBStatusTitle class],
             @"pic_infos" : [YWBPicInfo class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    _pics = nil;
    if (_pic_ids.count != 0) {
        NSMutableArray *pics = [NSMutableArray new];
        for (NSString *picId in _pic_ids) {
            YWBPicInfo *pic = _pic_infos[picId];
            if (pic) {
                [pics addObject:pic];
            }
        }
        _pics = pics;
    }
    if (_retweeted_status) {
        if (_retweeted_status.url_struct.count == 0) {
            _retweeted_status.url_struct = _url_struct;
        }
        if (_retweeted_status.page_info == nil) {
            _retweeted_status.page_info = _page_info;
        }
    }
    return YES;
    
}

- (void)y_layout {
    _user.status = self;
    if (!_toobarM) {
        _toobarM = [YWBToolbar new];
    }
    if (!_contentM) {
        _contentM = [YWBContent new];
    }
    _toobarM.status = self;
    _contentM.status = self;
    
    [_title y_layout];
    [_user y_layout];
    [_contentM y_layout];
    [_tag_struct.firstObject y_layout];
    [_toobarM y_layout];
    [self cellHeight];
}

- (CGFloat)cellHeight {
    if (_cellHeight < 1.) {
        _cellHeight = kWBCellTopMargin;
        _cellHeight += _title.titleHeight;
        _cellHeight += _user.profileHeight;
        _cellHeight += _toobarM.toolbarHeight;
        _cellHeight += _contentM.textHeight;
        _cellHeight += _contentM.picHeight;
        _cellHeight += _contentM.retweetHeight;
        _cellHeight += _contentM.cardHeight;
        if (_contentM.retweetHeight < 0.1 && _contentM.cardHeight > 0.1) {
            _cellHeight += kWBCellPadding;
        }
        _cellHeight += _tag_struct.firstObject.tagHeight;
        _cellHeight += kWBCellToolbarBottomMargin;
    }
    return _cellHeight;
}

@end


#pragma mark - YWBPicInfo
@implementation YWBPicInfo

+ (NSArray *)modelPropertyBlacklist {
    return @[@"badgeType"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"thumbnail"   : [YWBPicMetadata class],
             @"bmiddle"     : [YWBPicMetadata class],
             @"middle_plus" : [YWBPicMetadata class],
             @"large"       : [YWBPicMetadata class],
             @"largest"     : [YWBPicMetadata class],
             @"original"    : [YWBPicMetadata class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    YWBPicMetadata *meta = _large ? _large : _largest ? _largest : _original;
    _badgeType = meta.badgeType;
    return YES;
}

@end

#pragma mark - YWBPicMetadata
@implementation YWBPicMetadata

+ (NSArray *)modelPropertyBlacklist {
    return @[@"badgeType"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([_type isEqualToString:@"GIF"]) {
        _badgeType = YWBPicBadgeTypeGIF;
    } else {
        if (_width > 0 && (float)_height / _width > 3) {
            _badgeType = YWBPicBadgeTypeLong;
        }
    }
    return YES;
}

@end


#pragma mark - YWBURLStruct
@implementation YWBURLStruct

+ (NSArray *)modelPropertyBlacklist {
    return @[@"pics"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pic_infos" : [YWBPicInfo class],
             @"pic_ids" : [NSString class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    _pics = nil;
    if (_pic_ids.count != 0) {
        NSMutableArray *pics = [NSMutableArray new];
        for (NSString *picId in _pic_ids) {
            YWBPicInfo *pic = _pic_infos[picId];
            if (pic) {
                [pics addObject:pic];
            }
        }
        _pics = pics;
    }
    
    return YES;
    
}

@end

#pragma mark - YWBPageInfo
@implementation YWBPageInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"buttons" : [YWBButtonLink class]};
}

@end

#pragma mark - YWBButtonLink
@implementation YWBButtonLink



@end


#pragma mark - YWBTopicStruct
@implementation YWBTopicStruct



@end

