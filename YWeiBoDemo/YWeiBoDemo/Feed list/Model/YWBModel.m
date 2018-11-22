//
//  YWBModel.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBModel.h"

@implementation YWBModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"ad" : [YWBAdModel class],
             @"advertises" : [NSString class],
             @"statuses" : [YWBStatuse class],
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

#pragma mark - YWBStatuse
@implementation YWBStatuse

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
             @"title" : [YWBStatusTitle class]
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

@end


@implementation YWBStatusTitle



@end

#pragma mark - YWBUser
@implementation YWBUser

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"id",
             @"desc" : @"description"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _gender = YWBGenderUnknown;
    NSString *gender = [dic valueForKey:@"gender"];
    if ([gender isEqualToString:@"m"]) {
        _gender = YWBGenderMale;
    } else if ([gender isEqualToString:@"f"]) {
        _gender = YWBGenderFemale;
    }
    
    // 这个不一定准。。
    if (_verified) {
        _user_verify_type = YWBUserVerifyTypeStandard;
    } else if (_verified_type == 220) {
        _user_verify_type = YWBUserVerifyTypeClub;
    } else if (_verified_type == -1 && _verified_level == 3) {
        _user_verify_type = YWBUserVerifyTypeOrganization;
    } else {
        _user_verify_type = YWBUserVerifyTypeNone;
    }
    return YES;
}

@end

#pragma mark - YWBPicInfo
@implementation YWBPicInfo

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

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pic_infos" : [YWBPicInfo class],
             @"pic_ids" : [NSString class]
             };
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


#pragma mark - YWBTagStruct
@implementation YWBTagStruct



@end
