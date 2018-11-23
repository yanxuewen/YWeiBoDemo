//
//  YWBUser.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBUser.h"
#import "YWBStatusHelper.h"
#import "YWBModel.h"

@implementation YWBUser

+ (NSArray *)modelPropertyBlacklist {
    return @[@"gender",@"profileHeight",@"nameTextLayout",@"sourceTextLayout",@"status"];
}

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
        _userVerifyType = YWBUserVerifyTypeStandard;
    } else if (_verified_type == 220) {
        _userVerifyType = YWBUserVerifyTypeClub;
    } else if (_verified_type == -1 && _verified_level == 3) {
        _userVerifyType = YWBUserVerifyTypeOrganization;
    } else {
        _userVerifyType = YWBUserVerifyTypeNone;
    }
    return YES;
}

- (void)y_layout {
    _profileHeight = kWBCellProfileHeight;
    [self y_layoutName];
    [self y_layoutSource];
}

/// 名字
- (void)y_layoutName {
    NSString *nameStr = nil;
    if (_remark.length) {
        nameStr = _remark;
    } else if (_screen_name.length) {
        nameStr = _screen_name;
    } else {
        nameStr = _name;
    }
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    // 蓝V
    if (_userVerifyType == YWBUserVerifyTypeOrganization) {
        UIImage *blueVImage = [YWBStatusHelper imageNamed:@"avatar_enterprise_vip"];
        NSAttributedString *blueVText = [YWBStatusHelper attachmentWithFontSize:kWBCellNameFontSize image:blueVImage shrink:NO];
        [nameText appendString:@" "];
        [nameText appendAttributedString:blueVText];
    }
    
    // VIP
    if (_mbrank > 0) {
        UIImage *yelllowVImage = [YWBStatusHelper imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%zi",_mbrank]];
        if (!yelllowVImage) {
            yelllowVImage = [YWBStatusHelper imageNamed:@"common_icon_membership"];
        }
        NSAttributedString *vipText = [YWBStatusHelper attachmentWithFontSize:kWBCellNameFontSize image:yelllowVImage shrink:NO];
        [nameText appendString:@" "];
        [nameText appendAttributedString:vipText];
    }
    
    nameText.font = kSystemFont(kWBCellNameFontSize);
    nameText.color = _mbrank > 0 ? kWBCellNameOrangeColor : kWBCellNameNormalColor;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}

/// 时间和来源
- (void)y_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = [YWBStatusHelper stringWithTimelineDate:_status.created_at];
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        timeText.color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
    }
    
    // 来自 XXX
    if (_status.source.length) {
        // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
        static NSRegularExpression *hrefRegex, *textRegex;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hrefRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\").+(?=\" )" options:kNilOptions error:NULL];
            textRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:kNilOptions error:NULL];
        });
        NSTextCheckingResult *hrefResult, *textResult;
        NSString *href = nil, *text = nil;
        hrefResult = [hrefRegex firstMatchInString:_status.source options:kNilOptions range:NSMakeRange(0, _status.source.length)];
        textResult = [textRegex firstMatchInString:_status.source options:kNilOptions range:NSMakeRange(0, _status.source.length)];
        if (hrefResult && textResult && hrefResult.range.location != NSNotFound && textResult.range.location != NSNotFound) {
            href = [_status.source substringWithRange:hrefResult.range];
            text = [_status.source substringWithRange:textResult.range];
        }
        if (href.length && text.length) {
            NSMutableAttributedString *from = [NSMutableAttributedString new];
            [from appendString:[NSString stringWithFormat:@"来自 %@", text]];
            from.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
            from.color = kWBCellTimeNormalColor;
            if (_status.source_allowclick > 0) {
                NSRange range = NSMakeRange(3, text.length);
                [from setColor:kWBCellTextHighlightColor range:range];
                YYTextBackedString *backed = [YYTextBackedString stringWithString:href];
                [from setTextBackedString:backed range:range];
                
                YYTextBorder *border = [YYTextBorder new];
                border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
                border.fillColor = kWBCellTextHighlightBackgroundColor;
                border.cornerRadius = 3;
                YYTextHighlight *highlight = [YYTextHighlight new];
                if (href) highlight.userInfo = @{kWBLinkHrefName : href};
                [highlight setBackgroundBorder:border];
                [from setTextHighlight:highlight range:range];
            }
            
            [sourceText appendAttributedString:from];
        }
    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}

@end
