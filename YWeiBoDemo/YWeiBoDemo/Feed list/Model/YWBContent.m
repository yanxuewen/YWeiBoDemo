//
//  YWBContent.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/27.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YWBContent.h"
#import "YWBStatusHelper.h"
#import "YWBModel.h"

@implementation YWBContent

- (void)y_layout {
    [self y_layoutText];
    [self y_layoutRetweetedText];
}

/// 文本
- (void)y_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self y_textWithStatus:_status
                                                  isRetweet:NO
                                                   fontSize:kWBCellTextFontSize
                                                  textColor:kWBCellTextNormalColor];
    if (text.length == 0) return;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.insets = UIEdgeInsetsMake(kWBCellPaddingText, 0, kWBCellPaddingText, 0);
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = _textLayout.textBoundingSize.height;
}


- (void)y_layoutRetweetedText {
    _retweetHeight = 0;
    _retweetTextLayout = nil;
    NSMutableAttributedString *text = [self y_textWithStatus:_status.retweeted_status
                                                  isRetweet:YES
                                                   fontSize:kWBCellTextFontRetweetSize
                                                  textColor:kWBCellTextSubTitleColor];
    if (text.length == 0) return;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.insets = UIEdgeInsetsMake(kWBCellPaddingText, 0, kWBCellPaddingText, 0);
    
    _retweetTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_retweetTextLayout) return;
    
    _retweetTextHeight = _retweetTextLayout.textBoundingSize.height;
}


- (NSMutableAttributedString *)y_textWithStatus:(YWBStatus *)status
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!status) return nil;
    
    NSMutableString *string = status.text.mutableCopy;
    if (string.length == 0) return nil;
    if (isRetweet) {
        NSString *name = status.user.name;
        if (name.length == 0) {
            name = status.user.screen_name;
        }
        if (name) {
            NSString *insert = [NSString stringWithFormat:@"@%@:",name];
            [string insertString:insert atIndex:0];
        }
    }
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.font = font;
    text.color = textColor;
    
    // 根据 urlStruct 中每个 URL.short_url 来匹配文本，将其替换为图标+友好描述
    for (YWBURLStruct *wburl in status.url_struct) {
        if (wburl.short_url.length == 0) continue;
        if (wburl.url_title.length == 0) continue;
        NSString *urlTitle = wburl.url_title;
        if (urlTitle.length > 27) {
            urlTitle = [[urlTitle substringToIndex:27] stringByAppendingString:YYTextTruncationToken];
        }
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:wburl.short_url options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if (range.location + range.length == text.length) {
                if (status.page_info.page_id && wburl.page_id &&
                    [wburl.page_id isEqualToString:status.page_info.page_id]) {
                    if ((!isRetweet && !status.retweeted_status) || isRetweet) {
                        if (status.pics.count == 0) {
                            [text replaceCharactersInRange:range withString:@""];
                            break; // cut the tail, show with card
                        }
                    }
                }
            }
            
            if ([text attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                
                // 替换的内容
                NSMutableAttributedString *replace = [[NSMutableAttributedString alloc] initWithString:urlTitle];
                if (wburl.url_type_pic.length) {
                    // 链接头部有个图片附件 (要从网络获取)
                    NSURL *picURL = [YWBStatusHelper defaultURLForImageURL:wburl.url_type_pic];
                    UIImage *image = [[YYImageCache sharedCache] getImageForKey:picURL.absoluteString];
                    NSAttributedString *pic = (image && !wburl.pics.count) ? [YWBStatusHelper attachmentWithFontSize:fontSize image:image shrink:YES] : [YWBStatusHelper attachmentWithFontSize:fontSize imageURL:wburl.url_type_pic shrink:YES];
                    [replace insertAttributedString:pic atIndex:0];
                }
                replace.font = font;
                replace.color = kWBCellTextHighlightColor;
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkURLName : wburl};
                [replace setTextHighlight:highlight range:NSMakeRange(0, replace.length)];
                
                // 添加被替换的原始字符串，用于复制
                YYTextBackedString *backed = [YYTextBackedString stringWithString:[text.string substringWithRange:range]];
                [replace setTextBackedString:backed range:NSMakeRange(0, replace.length)];
                
                // 替换
                [text replaceCharactersInRange:range withAttributedString:replace];
                
                searchRange.location = searchRange.location + (replace.length ? replace.length : 1);
                if (searchRange.location + 1 >= text.length) break;
                searchRange.length = text.length - searchRange.location;
            } else {
                searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
                if (searchRange.location + 1>= text.length) break;
                searchRange.length = text.length - searchRange.location;
            }
        } while (1);
    }
    
    // 根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
    for (YWBTopicStruct *topic in status.topic_struct) {
        if (topic.topic_title.length == 0) continue;
        NSString *topicTitle = [NSString stringWithFormat:@"#%@#",topic.topic_title];
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:topicTitle options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if ([text attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                [text setColor:kWBCellTextHighlightColor range:range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkTopicName : topic};
                [text setTextHighlight:highlight range:range];
            }
            searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
            if (searchRange.location + 1>= text.length) break;
            searchRange.length = text.length - searchRange.location;
        } while (1);
    }
    
    // 匹配 @用户名
    NSArray *atResults = [[YWBStatusHelper regexAt] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text setColor:kWBCellTextHighlightColor range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配 [表情]
    NSArray<NSTextCheckingResult *> *emoticonResults = [[YWBStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [YWBStatusHelper emoticonDic][emoString];
        UIImage *image = [YWBStatusHelper imageWithPath:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}


@end
