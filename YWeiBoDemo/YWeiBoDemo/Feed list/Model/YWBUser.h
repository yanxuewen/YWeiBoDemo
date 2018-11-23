//
//  YWBUser.h
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
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

NS_ASSUME_NONNULL_BEGIN

@class YWBStatus;

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
@property (nonatomic, strong) NSString *verified_source_url;
@property (nonatomic, strong) NSString *verified_reason;      ///< 微博认证描述
@property (nonatomic, strong) NSString *verified_reason_url;
@property (nonatomic, strong) NSString *verified_reason_modified;

@property (nonatomic, assign) YWBUserVerifyType userVerifyType;

// layout
@property (nonatomic, weak) YWBStatus *status;
@property (nonatomic, assign) CGFloat profileHeight;            // 个人资料高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout;     // 名字
@property (nonatomic, strong) YYTextLayout *sourceTextLayout;   // 时间/来源

@end

NS_ASSUME_NONNULL_END
