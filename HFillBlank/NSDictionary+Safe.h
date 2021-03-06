//
//  NSDictionary+Safe.h
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/27.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Safe)

- (NSString *)getString:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
