//
//  YWBModel.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"

typedef NS_ENUM(NSInteger,YWBGender) {
    YWBGenderUnknown = 0,
    YWBGenderMale,          ///< 男
    YWBGenderFemale,        ///< 女
};

///< 认证类型
typedef NS_ENUM(NSInteger, YWBUserVerifyType){
    YWBUserVerifyTypeNone = 0,     ///< 没有认证
    YWBUserVerifyTypeStandard,     ///< 个人认证，黄V
    YWBUserVerifyTypeOrganization, ///< 官方认证，蓝V
    YWBUserVerifyTypeClub,         ///< 达人认证，红星
};

/// 图片标记
typedef NS_ENUM(NSInteger, YWBPicBadgeType) {
    YWBPicBadgeTypeNone = 0, ///< 正常图片
    YWBPicBadgeTypeLong,     ///< 长图
    YWBPicBadgeTypeGIF,      ///< GIF
};

NS_ASSUME_NONNULL_BEGIN
@class YWBAdModel,YWBStatuse,YWBUser,YWBPicInfo,YWBPicMetadata;

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

@property (nonatomic, strong) NSArray<YWBStatuse *> *statuses; ///< 微博列表

@end

@interface YWBAdModel : YBaseModel

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *type;

@end

@class YWBURLStruct,YWBPageInfo,YWBTopicStruct,YWBTagStruct,YWBStatusTitle;
@interface YWBStatuse : YBaseModel

@property (nonatomic, assign) NSInteger mblogtype;
@property (nonatomic, strong) NSDate *created_at;               ///< 发布时间
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) NSUInteger idNum;

@property (nonatomic, strong) YWBUser *user;
@property (nonatomic, assign) NSInteger user_type;

@property (nonatomic, strong) YWBStatusTitle *title;             ///< 标题栏 (通常为nil)
@property (nonatomic, strong) NSString *pic_bg;                 ///< 微博VIP背景图，需要替换 "os7"
@property (nonatomic, strong) NSString *text;                   ///< 正文
@property (nonatomic, strong) NSURL *thumbnail_pic;             ///< 缩略图
@property (nonatomic, strong) NSURL *bmiddle_pic;               ///< 中图
@property (nonatomic, strong) NSURL *original_pic;              ///< 大图

@property (nonatomic, strong) YWBStatuse *retweeted_status;     ///< 转发微博

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
@property (nonatomic, assign) NSInteger source_allow_click;     ///< 来源是否允许点击

@property (nonatomic, strong) NSDictionary *geo;
@property (nonatomic, strong) NSArray *annotations;             ///< 地理位置
@property (nonatomic, assign) NSInteger biz_feature;
@property (nonatomic, assign) NSInteger mlevel;
@property (nonatomic, strong) NSString *mblogid;
@property (nonatomic, strong) NSString *mblog_type_name;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSDictionary *visible;
@property (nonatomic, strong) NSArray *darwin_tags;

@end

@interface YWBStatusTitle : YBaseModel

@property (nonatomic, assign) NSInteger baseColor;
@property (nonatomic, strong) NSString *text; ///< 文本，例如"仅自己可见"
@property (nonatomic, strong) NSString *icon_url; ///< 图标URL，需要加Default

@end

@interface YWBUser : YBaseModel

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) YWBGender gender;
@property (nonatomic, strong) NSString *desc;               ///< 个人简介
@property (nonatomic, strong) NSString *domain;             ///< 个性域名

@property (nonatomic, strong) NSString *name;               ///< 昵称
@property (nonatomic, strong) NSString *screen_name;        ///< 友好昵称
@property (nonatomic, strong) NSString *remark;             ///< 备注

@property (nonatomic, assign) NSInteger followers_count;    ///< 粉丝数
@property (nonatomic, assign) NSInteger friends_count;      ///< 关注数
@property (nonatomic, assign) NSInteger bi_followers_count; ///< 好友数 (双向关注)
@property (nonatomic, assign) NSInteger favourites_count;   ///< 收藏数
@property (nonatomic, assign) NSInteger statuses_count;     ///< 微博数
@property (nonatomic, assign) NSInteger topics_count;       ///< 话题数
@property (nonatomic, assign) NSInteger blocked_count;      ///< 屏蔽数
@property (nonatomic, assign) NSInteger pagefriends_count;
@property (nonatomic, assign) BOOL followMe;
@property (nonatomic, assign) BOOL following;

@property (nonatomic, strong) NSString *province;           ///< 省
@property (nonatomic, strong) NSString *city;               ///< 市

@property (nonatomic, strong) NSString *url;                ///< 博客地址
@property (nonatomic, strong) NSURL *profile_image_url;     ///< 头像 50x50 (FeedList)
@property (nonatomic, strong) NSURL *avatar_large;          ///< 头像 180*180
@property (nonatomic, strong) NSURL *avatar_hd;             ///< 头像 原图
@property (nonatomic, strong) NSURL *cover_image;           ///< 封面图 920x300
@property (nonatomic, strong) NSURL *cover_image_phone;

@property (nonatomic, strong) NSString *profile_url;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger ptype;
@property (nonatomic, assign) NSInteger mbtype;
@property (nonatomic, assign) NSInteger urank;              ///< 微博等级 (LV)
@property (nonatomic, assign) NSInteger uclass;
@property (nonatomic, assign) NSInteger ulevel;
@property (nonatomic, assign) NSInteger mbrank;             ///< 会员等级 (橙名 VIP)
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSDate *created_at;           ///< 注册时间
@property (nonatomic, assign) BOOL allow_all_act_msg;
@property (nonatomic, assign) BOOL allow_all_comment;
@property (nonatomic, assign) BOOL geo_enabled;
@property (nonatomic, assign) NSInteger online_status;
@property (nonatomic, strong) NSString *location;           ///< 所在地
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *icons;
@property (nonatomic, strong) NSString *weihao;
@property (nonatomic, strong) NSString *badge_top;
@property (nonatomic, assign) NSInteger block_word;
@property (nonatomic, assign) NSInteger block_app;
@property (nonatomic, assign) NSInteger has_ability_tag;
@property (nonatomic, assign) NSInteger credit_score;       ///< 信用积分
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *badge; ///< 勋章
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, assign) NSInteger user_ability;
@property (nonatomic, strong) NSDictionary *extend;

@property (nonatomic, assign) BOOL verified;                ///< 微博认证 (大V)
@property (nonatomic, assign) NSInteger verified_type;
@property (nonatomic, assign) NSInteger verified_level;
@property (nonatomic, assign) NSInteger verified_state;
@property (nonatomic, strong) NSString *verified_contact_email;
@property (nonatomic, strong) NSString *verified_contact_mobile;
@property (nonatomic, strong) NSString *verified_trade;
@property (nonatomic, strong) NSString *verified_contact_name;
@property (nonatomic, strong) NSString *verified_source;
@property (nonatomic, strong) NSString *verified_sourceURL;
@property (nonatomic, strong) NSString *verified_reason;      ///< 微博认证描述
@property (nonatomic, strong) NSString *verified_reason_url;
@property (nonatomic, strong) NSString *verified_reason_modified;

@property (nonatomic, assign) YWBUserVerifyType user_verify_type;

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
@property (nonatomic, assign) NSInteger cutType;            ///< Default:1
@property (nonatomic, assign) YWBPicBadgeType badgeType;

@end

@interface YWBURLStruct : YBaseModel

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSString *short_url;      ///< 短域名 (原文)
@property (nonatomic, strong) NSString *ori_url;        ///< 原始链接
@property (nonatomic, strong) NSString *url_title;      ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
@property (nonatomic, strong) NSString *url_typePic;    ///< 链接类型的图片URL
@property (nonatomic, assign) NSInteger url_type;        ///< 0:一般链接 36地点 39视频/图片
@property (nonatomic, strong) NSString *log;
@property (nonatomic, strong) NSDictionary *actionlog;
@property (nonatomic, strong) NSString *page_id;        ///< 对应着 WBPageInfo
@property (nonatomic, strong) NSString *storage_type;
//如果是图片，则会有下面这些，可以直接点开看
@property (nonatomic, strong) NSArray<NSString *> *pic_ids;
@property (nonatomic, strong) NSDictionary<NSString *, YWBPicInfo *> *pic_infos;

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
