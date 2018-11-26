//
//  YWBStatusTitle.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/23.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBStatusTitle.h"
#import "YWBStatusHelper.h"

@implementation YWBStatusTitle

+ (NSArray *)modelPropertyBlacklist {
    return @[@"titleHeight",@"titleTextLayout"];
}

- (void)y_layout {
    _titleHeight = 0.;
    _titleTextLayout = nil;
    
    if (_text.length == 0) return;
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:_text];
    if (_icon_url) {
//        NSAttributedString *icon = [self _attachmentWithFontSize:kWBCellTitlebarFontSize imageURL:title.iconURL shrink:NO];
//        if (icon) {
//            [attText insertAttributedString:icon atIndex:0];
//        }
    }
    attText.color = kWBCellToolbarTitleColor;
    attText.font = [UIFont systemFontOfSize:kWBCellTitlebarFontSize];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 100, kWBCellTitleHeight)];
    _titleTextLayout = [YYTextLayout layoutWithContainer:container text:attText];
    _titleHeight = kWBCellTitleHeight;
}

@end
