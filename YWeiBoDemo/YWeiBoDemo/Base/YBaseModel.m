//
//  YBaseModel.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/22.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YBaseModel.h"


@implementation YBaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

@end
