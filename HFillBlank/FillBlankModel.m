//
//  FillBlankModel.m
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/27.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import "FillBlankModel.h"
#import <YYText/YYText.h>
@implementation FillBlankModel


- (void)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    if (!string.length) {
        return;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableArray *array = [NSMutableArray array];
    self.blankRangeArray = [NSMutableArray array];
    NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    int diff = 0;
    for (int i=0; i<matches.count; i++) {
        NSTextCheckingResult *match = [matches objectAtIndex:i];
        NSString *userAnswer = self.userInputedStr;
        [jsonArray addObject:userAnswer];
        NSRange resultRange = match.range;
        NSUInteger blankLength = 8;
        blankLength += userAnswer.length;
        NSRange newRange = NSMakeRange(match.range.location-diff, blankLength);
        [self.blankRangeArray addObject:NSStringFromRange(newRange)];
        NSUInteger currentDiff = match.range.length-blankLength;
        diff += currentDiff;
        NSString *resultStr = @"";
        int halfLength = 4;
        for (int i=0; i<halfLength; i++) {
            resultStr = [resultStr stringByAppendingString:@" "];
        }
        if (userAnswer.length) {
          resultStr = [resultStr stringByAppendingString:userAnswer];
        }
        for (int i=0; i<halfLength; i++) {
            resultStr = [resultStr stringByAppendingString:@" "];
        }
        NSDictionary *dic = @{@"oldrange":[NSValue valueWithRange:resultRange],@"newStr":resultStr};
        [array addObject:dic];
    }
    for (int i = (int)array.count - 1; i >= 0; i --) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *newStr = [dic objectForKey:@"newStr"];
        NSRange range = [[dic objectForKey:@"oldrange"] rangeValue];
        string = [string stringByReplacingCharactersInRange:range withString:newStr];
    }
    [self showAttrbutedTextWithString:string];
}
- (void)showAttrbutedTextWithString:(NSString *)blankStr{
    if (!blankStr.length) {
        return;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:blankStr];
    self.bindStrArray = [[NSMutableArray alloc] init];
    NSUInteger startLocation = 0;
    for (int i=0; i<self.blankRangeArray.count; i++) {
        NSString *blRange = [self.blankRangeArray objectAtIndex:i];
        NSString *userAnswer = self.userInputedStr;

        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSRange bRange = NSRangeFromString(blRange);
        NSRange subRange = NSMakeRange(startLocation,bRange.location-startLocation + (bRange.length-userAnswer.length)/2);
        NSString *subStr = [blankStr substringWithRange:subRange];
        NSString *subRangeStr = NSStringFromRange(subRange);
        [newDict setObject:subStr forKey:@"bind_str"];
        [newDict setObject:subRangeStr forKey:@"bind_range"];
        [self.bindStrArray addObject:newDict];
        startLocation = bRange.location + (bRange.length-userAnswer.length)/2 + userAnswer.length;
    }
    if (self.blankRangeArray.count && startLocation < blankStr.length) {
        NSRange lastRange = NSMakeRange(startLocation, blankStr.length-startLocation);
        NSString *subStr = [blankStr substringWithRange:lastRange];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict setObject:subStr forKey:@"bind_str"];
        [newDict setObject:NSStringFromRange(lastRange) forKey:@"bind_range"];
        [self.bindStrArray addObject:newDict];
    }
    for (NSDictionary *newDict in self.bindStrArray) {
        NSRange bindRange = NSRangeFromString([newDict getString:@"bind_range"]);
        [self addBackBinding:att withText:[newDict getString:@"bind_str"] range:bindRange];
        
    }
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:att.yy_rangeOfAll];
    
    for (int i=0 ; i<self.blankRangeArray.count; i++) {
        NSString *blankRangeStr = [self.blankRangeArray objectAtIndex:i];
        NSRange lineRange = NSRangeFromString(blankRangeStr);
        [self attSetUnderLine:att byRange:lineRange];
    }
    
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:att.yy_rangeOfAll];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:15];
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:att.yy_rangeOfAll];
    self.blankAttributedStr = att;
}

-(void)addBackBinding:(NSMutableAttributedString *)att withText:(NSString *)string range:(NSRange)range{
    NSMutableAttributedString *replace=[[NSMutableAttributedString alloc] initWithString:string];
    
    YYTextBackedString *backed = [YYTextBackedString stringWithString:string];
    [replace yy_setTextBackedString:backed range:NSMakeRange(0, string.length)];

    [replace yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:YES] range:NSMakeRange(0, string.length)];
    [att replaceCharactersInRange:range withAttributedString:replace];
}

-(void)attSetUnderLine:(NSMutableAttributedString *)att byRange:(NSRange)range{
    [att yy_setUnderlineColor:[UIColor blackColor] range:range];
    [att yy_setBaselineOffset:@(0) range:range];
    [att yy_setUnderlineStyle:NSUnderlineStyleSingle range:range];
}

@end
