//
//  YWBEmoticon.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBEmoticon.h"

@implementation YWBEmoticon

+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}

@end


@implementation YWBEmoticonGroup

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"nameCN" : @"group_name_cn",
             @"nameEN" : @"group_name_en",
             @"nameTW" : @"group_name_tw",
             @"displayOnly" : @"display_only",
             @"groupType" : @"group_type"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emoticons" : [YWBEmoticon class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emoticons enumerateObjectsUsingBlock:^(YWBEmoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}

@end
