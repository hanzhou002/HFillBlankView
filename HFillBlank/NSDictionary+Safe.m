//
//  NSDictionary+Safe.m
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/27.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import "NSDictionary+Safe.h"
@implementation NSDictionary (Safe)

- (NSString *)getString:(NSString *)key
{
    return [self getString:key withDefault:@""];
}
- (NSString *)getString:(NSString *)key withDefault:(NSString *)d
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value respondsToSelector:@selector(stringValue)]) return [value stringValue];
    return d;
}

@end
