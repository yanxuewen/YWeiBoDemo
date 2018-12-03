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
    [self y_layoutRetweet];
    if (_retweetHeight < 0.1) {
        [self y_layoutPicsWithStatus:_status isRetweet:NO];
        if (_picHeight < 0.1) {
            [self y_layoutCardWithStatus:_status isRetweet:NO];
        }
    }
}

- (void)y_layoutRetweet {
    _retweetHeight = 0;
    [self y_layoutRetweetedText];
    [self y_layoutPicsWithStatus:_status.retweeted_status isRetweet:YES];
    if (_retweetPicHeight == 0) {
        [self y_layoutCardWithStatus:_status.retweeted_status isRetweet:YES];
    }
    
    _retweetHeight = _retweetTextHeight;
    if (_retweetPicHeight > 0) {
        _retweetHeight += _retweetPicHeight;
        _retweetHeight += kWBCellPadding;
    } else if (_retweetCardHeight > 0) {
        _retweetHeight += _retweetCardHeight;
        _retweetHeight += kWBCellPadding;
    }
}

#pragma mark - layout text
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
    
    // 根据 url_struct 中每个 URL.short_url 来匹配文本，将其替换为图标+友好描述
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

#pragma mark - layout pic
- (void)y_layoutPicsWithStatus:(YWBStatus *)status isRetweet:(BOOL)isRetweet {
    if (isRetweet) {
        _retweetPicSize = CGSizeZero;
        _retweetPicHeight = 0;
    } else {
        _picSize = CGSizeZero;
        _picHeight = 0;
    }
    if (status.pics.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (status.pics.count) {
        case 1: {
            YWBPicInfo *pic = _status.pics.firstObject;
            YWBPicMetadata *bmiddle = pic.bmiddle;
            if (pic.keep_size || bmiddle.width < 1 || bmiddle.height < 1) {
                CGFloat maxLen = kWBCellContentWidth / 2.0;
                maxLen = CGFloatPixelRound(maxLen);
                picSize = CGSizeMake(maxLen, maxLen);
                picHeight = maxLen;
            } else {
                CGFloat maxLen = len1_3 * 2 + kWBCellPaddingPic;
                if (bmiddle.width < bmiddle.height) {
                    picSize.width = (float)bmiddle.width / (float)bmiddle.height * maxLen;
                    picSize.height = maxLen;
                } else {
                    picSize.width = maxLen;
                    picSize.height = (float)bmiddle.height / (float)bmiddle.width * maxLen;
                }
                picSize = CGSizePixelRound(picSize);
                picHeight = picSize.height;
            }
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    
    if (isRetweet) {
        _retweetPicSize = picSize;
        _retweetPicHeight = picHeight;
    } else {
        _picSize = picSize;
        _picHeight = picHeight + kWBCellPadding;
    }
}


- (void)y_layoutCardWithStatus:(YWBStatus *)status isRetweet:(BOOL)isRetweet {
    if (isRetweet) {
        _retweetCardType = YWBStatusCardTypeNone;
        _retweetCardHeight = 0;
        _retweetCardTextLayout = nil;
        _retweetCardTextRect = CGRectZero;
    } else {
        _cardType = YWBStatusCardTypeNone;
        _cardHeight = 0;
        _cardTextLayout = nil;
        _cardTextRect = CGRectZero;
    }
    YWBPageInfo *pageInfo = status.page_info;
    if (!pageInfo) return;
    
    YWBStatusCardType cardType = YWBStatusCardTypeNone;
    CGFloat cardHeight = 0;
    YYTextLayout *cardTextLayout = nil;
    CGRect textRect = CGRectZero;
    
    if ((pageInfo.type == 11) && [pageInfo.object_type isEqualToString:@"video"]) {
        // 视频，一个大图片，上面播放按钮
        if (pageInfo.page_pic) {
            cardType = YWBStatusCardTypeVideo;
            cardHeight = (2 * kWBCellContentWidth - kWBCellPaddingPic) / 3.0;
        }
    } else {
        BOOL hasImage = pageInfo.page_pic != nil;
        BOOL hasBadge = pageInfo.type_icon != nil;
        YWBButtonLink *button = pageInfo.buttons.firstObject;
        BOOL hasButtom = button.pic && button.name;
        
        /*
         badge: 25,25 左上角 (42)
         image: 70,70 方形
         100, 70 矩形
         btn:  60,70
         
         lineheight 20
         padding 10
         */
        textRect.size.height = 70;
        if (hasImage) {
            if (hasBadge) {
                textRect.origin.x = 100;
            } else {
                textRect.origin.x = 70;
            }
        } else {
            if (hasBadge) {
                textRect.origin.x = 42;
            }
        }
        textRect.origin.x += 10; //padding
        textRect.size.width = kWBCellContentWidth - textRect.origin.x;
        if (hasButtom) textRect.size.width -= 60;
        textRect.size.width -= 10; //padding
        
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        if (pageInfo.page_title.length) {
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:pageInfo.page_title];
            
            title.font = [UIFont systemFontOfSize:kWBCellCardTitleFontSize];
            title.color = kWBCellNameNormalColor;
            [text appendAttributedString:title];
        }
        
        if (pageInfo.page_desc.length) {
            if (text.length) [text appendString:@"\n"];
            NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:pageInfo.page_desc];
            desc.font = [UIFont systemFontOfSize:kWBCellCardDescFontSize];
            desc.color = kWBCellNameNormalColor;
            [text appendAttributedString:desc];
        } else if (pageInfo.content2.length) {
            if (text.length) [text appendString:@"\n"];
            NSMutableAttributedString *content3 = [[NSMutableAttributedString alloc] initWithString:pageInfo.content2];
            content3.font = [UIFont systemFontOfSize:kWBCellCardDescFontSize];
            content3.color = kWBCellTextSubTitleColor;
            [text appendAttributedString:content3];
        } else if (pageInfo.content3.length) {
            if (text.length) [text appendString:@"\n"];
            NSMutableAttributedString *content3 = [[NSMutableAttributedString alloc] initWithString:pageInfo.content3];
            content3.font = [UIFont systemFontOfSize:kWBCellCardDescFontSize];
            content3.color = kWBCellTextSubTitleColor;
            [text appendAttributedString:content3];
        }
        
        if (pageInfo.tips.length) {
            if (text.length) [text appendString:@"\n"];
            NSMutableAttributedString *tips = [[NSMutableAttributedString alloc] initWithString:pageInfo.tips];
            tips.font = [UIFont systemFontOfSize:kWBCellCardDescFontSize];
            tips.color = kWBCellTextSubTitleColor;
            [text appendAttributedString:tips];
        }
        
        if (text.length) {
            text.maximumLineHeight = 20;
            text.minimumLineHeight = 20;
            text.lineBreakMode = NSLineBreakByTruncatingTail;
            
            YYTextContainer *container = [YYTextContainer containerWithSize:textRect.size];
            container.maximumNumberOfRows = 3;
            cardTextLayout = [YYTextLayout layoutWithContainer:container text:text];
        }
        
        if (cardTextLayout) {
            cardType = YWBStatusCardTypeNormal;
            cardHeight = 70;
        }
    }
    
    if (isRetweet) {
        _retweetCardType = cardType;
        _retweetCardHeight = cardHeight;
        _retweetCardTextLayout = cardTextLayout;
        _retweetCardTextRect = textRect;
    } else {
        _cardType = cardType;
        _cardHeight = cardHeight;
        _cardTextLayout = cardTextLayout;
        _cardTextRect = textRect;
    }
    
}



@end
