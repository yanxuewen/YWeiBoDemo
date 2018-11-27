//
//  YWBTagStruct.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBTagStruct.h"
#import "YWBStatusHelper.h"
#import "YWBModel.h"

@implementation YWBTagStruct

+ (NSArray *)modelPropertyBlacklist {
    return @[@"tagHeight",@"tagType",@"tagTextLayout"];
}

- (void)y_layout {
    _tagType = YWBStatusTagTypeNone;
    _tagHeight = 0;
    
    YWBTagStruct *tag = self;
    if (tag.tag_name.length == 0) return;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tag.tag_name];
    if (tag.tag_type == 1) {
        _tagType = YWBStatusTagTypePlace;
        _tagHeight = 40;
        text.color = [UIColor colorWithWhite:0.217 alpha:1.000];
    } else {
        _tagType = YWBStatusTagTypeNormal;
        _tagHeight = 32;
        if (tag.url_type_pic) {
            NSAttributedString *pic = [YWBStatusHelper attachmentWithFontSize:kWBCellCardDescFontSize imageURL:tag.url_type_pic.absoluteString shrink:YES];
            [text insertAttributedString:pic atIndex:0];
        }
        // 高亮状态的背景
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
        highlightBorder.cornerRadius = 2;
        highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
        
        [text setColor:kWBCellTextHighlightColor range:text.rangeOfAll];
        
        // 高亮状态
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        // 数据信息，用于稍后用户点击
        highlight.userInfo = @{kWBLinkTagName : tag};
        [text setTextHighlight:highlight range:text.rangeOfAll];
    }
    text.font = [UIFont systemFontOfSize:kWBCellCardDescFontSize];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(9999, 9999)];
    _tagTextLayout = [YYTextLayout layoutWithContainer:container text:text];

    if (!_tagTextLayout) {
        _tagType = YWBStatusTagTypeNone;
        _tagHeight = 0;
    }
}

@end
