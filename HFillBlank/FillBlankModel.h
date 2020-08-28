//
//  FillBlankModel.h
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/27.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Safe.h"
@interface FillBlankModel : NSObject

@property (nonatomic, strong) NSMutableArray *blankRangeArray;
@property (nonatomic, strong) NSMutableArray *bindStrArray;
@property (nonatomic, strong) NSArray *submitStrArray;
@property (nonatomic, copy) NSString *userInputedStr;

@property (nonatomic, strong) NSAttributedString *blankAttributedStr;

- (void)matchString:(NSString *)string toRegexString:(NSString *)regexStr;

@end

