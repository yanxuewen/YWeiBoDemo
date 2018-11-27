//
//  YWBEmoticon.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

typedef NS_ENUM(NSUInteger, YWBEmoticonType) {
    YWBEmoticonTypeImage = 0, ///< 图片表情
    YWBEmoticonTypeEmoji = 1, ///< Emoji表情
};

NS_ASSUME_NONNULL_BEGIN

@class YWBEmoticonGroup;

@interface YWBEmoticon : YBaseModel

@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) YWBEmoticonType type;
@property (nonatomic, weak) YWBEmoticonGroup *group;

@end

@interface YWBEmoticonGroup : YBaseModel
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN; ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray<YWBEmoticon *> *emoticons;
@end

NS_ASSUME_NONNULL_END
