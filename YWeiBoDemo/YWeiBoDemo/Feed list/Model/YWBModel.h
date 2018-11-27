//
//  YWBModel.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"
#import "YWBStatusTitle.h"
#import "YWBUser.h"
#import "YWBToolbar.h"
#import "YWBContent.h"


/// 图片标记
typedef NS_ENUM(NSInteger, YWBPicBadgeType) {
    YWBPicBadgeTypeNone = 0, ///< 正常图片
    YWBPicBadgeTypeLong,     ///< 长图
    YWBPicBadgeTypeGIF,      ///< GIF
};

NS_ASSUME_NONNULL_BEGIN
@class YWBAdModel,YWBStatus,YWBPicInfo,YWBPicMetadata;

@interface YWBModel : YBaseModel

@property (nonatomic, assign) BOOL hasvisible;
@property (nonatomic, strong) NSString *gsid;
@property (nonatomic, assign) NSInteger interval;
@property (nonatomic, strong) NSArray *advertises;
@property (nonatomic, assign) NSInteger previous_cursor;
@property (nonatomic, assign) NSInteger uve_blank;
@property (nonatomic, assign) NSInteger total_number;
@property (nonatomic, assign) NSInteger has_unread;
@property (nonatomic, assign) NSUInteger max_id;
@property (nonatomic, strong) NSArray<YWBAdModel *> *ad;

@property (nonatomic, strong) NSArray<YWBStatus *> *statuses; ///< 微博列表

@end


@interface YWBAdModel : YBaseModel

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *type;

@end


@class YWBURLStruct,YWBPageInfo,YWBTopicStruct,YWBTagStruct;
@interface YWBStatus : YBaseModel

@property (nonatomic, assign) NSInteger mblogtype;
@property (nonatomic, strong) NSDate *created_at;               ///< 发布时间
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) NSUInteger idNum;

@property (nonatomic, strong) YWBUser *user;
@property (nonatomic, assign) NSInteger user_type;

@property (nonatomic, strong) YWBStatusTitle *title;            ///< 标题栏 (通常为nil)
@property (nonatomic, strong) NSString *pic_bg;                 ///< 微博VIP背景图，需要替换 "os7"
@property (nonatomic, strong) NSString *text;                   ///< 正文
@property (nonatomic, strong) NSURL *thumbnail_pic;             ///< 缩略图
@property (nonatomic, strong) NSURL *bmiddle_pic;               ///< 中图
@property (nonatomic, strong) NSURL *original_pic;              ///< 大图

@property (nonatomic, strong) YWBStatus *retweeted_status;     ///< 转发微博

@property (nonatomic, strong) NSArray<NSString *> *pic_ids;
@property (nonatomic, strong) NSDictionary<NSString *, YWBPicInfo *> *pic_infos;

@property (nonatomic, strong) NSArray<YWBPicInfo *> *pics;
@property (nonatomic, strong) NSArray<YWBURLStruct *> *url_struct;
@property (nonatomic, strong) NSArray<YWBTopicStruct *> *topic_struct;
@property (nonatomic, strong) NSArray<YWBTagStruct *> *tag_struct;
@property (nonatomic, strong) YWBPageInfo *page_info;

@property (nonatomic, assign) BOOL favorited;                   ///< 是否收藏
@property (nonatomic, assign) BOOL truncated;                   ///< 是否截断
@property (nonatomic, assign) NSInteger reposts_count;          ///< 转发数
@property (nonatomic, assign) NSInteger comments_count;         ///< 评论数
@property (nonatomic, assign) NSInteger attitudes_count;        ///< 赞数
@property (nonatomic, assign) NSInteger attitudes_status;       ///< 是否已赞 0:没有
@property (nonatomic, assign) NSInteger recom_state;

@property (nonatomic, strong) NSString *in_reply_to_screen_name;
@property (nonatomic, strong) NSString *in_reply_to_status_id;
@property (nonatomic, strong) NSString *in_reply_to_user_id;

@property (nonatomic, strong) NSString *source;                 ///< 来自 XXX
@property (nonatomic, assign) NSInteger source_type;
@property (nonatomic, assign) NSInteger source_allowclick;     ///< 来源是否允许点击

@property (nonatomic, strong) NSDictionary *geo;
@property (nonatomic, strong) NSArray *annotations;             ///< 地理位置
@property (nonatomic, assign) NSInteger biz_feature;
@property (nonatomic, assign) NSInteger mlevel;
@property (nonatomic, strong) NSString *mblogid;
@property (nonatomic, strong) NSString *mblog_type_name;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSDictionary *visible;
@property (nonatomic, strong) NSArray *darwin_tags;

// layout
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) YWBToolbar *toobarM;
@property (nonatomic, strong) YWBContent *contentM;

@end




@interface YWBPicInfo : YBaseModel

@property (nonatomic, strong) NSString *pic_id;
@property (nonatomic, strong) NSString *object_id;
@property (nonatomic, assign) NSInteger photo_tag;
@property (nonatomic, assign) BOOL keep_size;               ///< YES:固定为方形 NO:原始宽高比
@property (nonatomic, strong) YWBPicMetadata *thumbnail;    ///< w:180
@property (nonatomic, strong) YWBPicMetadata *bmiddle;      ///< w:360 (列表中的缩略图)
@property (nonatomic, strong) YWBPicMetadata *middle_plus;  ///< w:480
@property (nonatomic, strong) YWBPicMetadata *large;        ///< w:720 (放大查看)
@property (nonatomic, strong) YWBPicMetadata *largest;      ///<       (查看原图)
@property (nonatomic, strong) YWBPicMetadata *original;
@property (nonatomic, assign) YWBPicBadgeType badgeType;

@end

@interface YWBPicMetadata : YBaseModel

@property (nonatomic, strong) NSURL *url;                   ///< Full image url
@property (nonatomic, assign) NSInteger width;              ///< pixel width
@property (nonatomic, assign) NSInteger height;             ///< pixel height
@property (nonatomic, strong) NSString *type;               ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) NSInteger cut_type;           ///< Default:1
@property (nonatomic, assign) YWBPicBadgeType badgeType;

@end

@interface YWBURLStruct : YBaseModel

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSString *short_url;      ///< 短域名 (原文)
@property (nonatomic, strong) NSString *ori_url;        ///< 原始链接
@property (nonatomic, strong) NSString *url_title;      ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
@property (nonatomic, strong) NSString *url_type_pic;    ///< 链接类型的图片URL
@property (nonatomic, assign) NSInteger url_type;        ///< 0:一般链接 36地点 39视频/图片
@property (nonatomic, strong) NSString *log;
@property (nonatomic, strong) NSDictionary *actionlog;
@property (nonatomic, strong) NSString *page_id;        ///< 对应着 WBPageInfo
@property (nonatomic, strong) NSString *storage_type;
//如果是图片，则会有下面这些，可以直接点开看
@property (nonatomic, strong) NSArray<NSString *> *pic_ids;
@property (nonatomic, strong) NSDictionary<NSString *, YWBPicInfo *> *pic_infos;
@property (nonatomic, strong) NSArray<YWBPicInfo *> *pics;

@end

@class YWBButtonLink;
@interface YWBPageInfo : YBaseModel

@property (nonatomic, strong) NSString *page_title;     ///< 页面标题，例如"上海·上海文庙"
@property (nonatomic, strong) NSString *page_id;
@property (nonatomic, strong) NSString *page_desc;      ///< 页面描述，例如"上海市黄浦区文庙路215号"
@property (nonatomic, strong) NSString *content1;
@property (nonatomic, strong) NSString *content2;
@property (nonatomic, strong) NSString *content3;
@property (nonatomic, strong) NSString *content4;
@property (nonatomic, strong) NSString *tips;           ///< 提示，例如"4222条微博"
@property (nonatomic, strong) NSString *object_type;    ///< 类型，例如"place" "video"
@property (nonatomic, strong) NSString *object_id;
@property (nonatomic, strong) NSString *scheme;         ///< 真实链接，例如 http://v.qq.com/xxx
@property (nonatomic, strong) NSArray<YWBButtonLink *> *buttons;

@property (nonatomic, assign) NSInteger is_asyn;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *page_url;       ///< 链接 sinaweibo://...
@property (nonatomic, strong) NSURL *page_pic;          ///< 图片URL，不需要加(_default) 通常是左侧的方形图片
@property (nonatomic, strong) NSURL *type_icon;         ///< Badge 图片URL，不需要加(_default) 通常放在最左上角角落里
@property (nonatomic, assign) NSInteger act_status;
@property (nonatomic, strong) NSDictionary *actionlog;
@property (nonatomic, strong) NSDictionary *media_info;

@end

@interface YWBButtonLink : YBaseModel

@property (nonatomic, strong) NSURL *pic;       ///< 按钮图片URL (需要加_default)
@property (nonatomic, strong) NSString *name;   ///< 按钮文本，例如"点评"
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *actionlog;

@end

@interface YWBTopicStruct : YBaseModel

@property (nonatomic, strong) NSString *topic_title; ///< 话题标题
@property (nonatomic, strong) NSString *topic_url;   ///< 话题链接 sinaweibo://

@end

@interface YWBTagStruct : YBaseModel

@property (nonatomic, strong) NSString *tag_name;    ///< 标签名字，例如"上海·上海文庙"
@property (nonatomic, strong) NSString *tag_scheme;  ///< 链接 sinaweibo://...
@property (nonatomic, assign) NSInteger tag_type;    ///< 1 地点 2其他
@property (nonatomic, assign) NSInteger tag_hidden;
@property (nonatomic, strong) NSURL *url_type_pic;   ///< 需要加 _default

@end

NS_ASSUME_NONNULL_END
