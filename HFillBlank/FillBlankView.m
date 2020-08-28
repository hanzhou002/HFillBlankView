//
//  FillBlankView.m
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/26.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import "FillBlankView.h"
#import "FillTextView.h"
#import "FillBlankModel.h"
@interface FillBlankView ()<YYTextViewDelegate>

@property (nonatomic, strong) FillTextView *blankTextView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *submitLabel;
@property (nonatomic, strong) FillBlankModel *model;

@end

@implementation FillBlankView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.blankTextView];
        [self addSubview:self.submitButton];
        [self addSubview:self.submitLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.blankTextView.frame = self.bounds;
    self.submitButton.frame = CGRectMake(self.bounds.size.width/2.0-60, self.bounds.size.height-200, 120, 60);
    self.submitLabel.frame = CGRectMake(0, self.submitButton.frame.origin.y+self.submitButton.frame.size.height+5, self.bounds.size.width, 100);
}

- (void)testWithIsShow:(BOOL)isShow{
    if (isShow) {
        self.model.userInputedStr = @"大白兔奶糖";
    }else{
        self.model.userInputedStr = @"";
    }
    NSString *pat = @"(_+)\\(\\)(_+)";
    NSString *regString = @"向晚意不适，驱车登古原。___()___，___()___。《乐游原》唐·李商隐 ";
    [self.model matchString:regString toRegexString:pat];
    self.blankTextView.attributedText = self.model.blankAttributedStr;
}


- (void)textViewDidBeginEditing:(YYTextView *)textView{
    NSRange range=textView.selectedRange;
   if (range.location <=0 || range.location >= textView.text.length) {
        [textView endEditing:YES];
   }
}

-(void)textViewDidChangeSelection:(YYTextView *)textView{
    NSRange range=textView.selectedRange;
    if (range.length>=1) {
        textView.selectedRange=NSMakeRange(range.location+range.length, 0);
    }
    if (range.location <=0 || range.location >= textView.text.length) {
        [textView endEditing:YES];
        return;
    }
    
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    NSUInteger beginLocation = 0;
    for (int i=0; i<self.model.bindStrArray.count; i++) {
        NSDictionary *beginDict = [self.model.bindStrArray objectAtIndex:i];
        NSString *beginStr = [beginDict getString:@"bind_str"];
        NSString *beginR = [self searchRangeWithTotalText:textView.attributedText.string WithKey:beginStr startLocation:beginLocation];
        if (beginR.length) {
            NSRange beginRange = NSRangeFromString(beginR);
            beginLocation = beginRange.location+beginRange.length;
        }
        NSRange subRange = NSRangeFromString(beginR);
        if (range.location==subRange.location && range.length==subRange.length) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView{
    
    NSMutableArray *submitArr = [[NSMutableArray alloc] init];
    NSUInteger beginLocation = 0;
    NSMutableArray *changeArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.model.blankRangeArray.count; i++) {
        int end = i+1;
        if (end < self.model.bindStrArray.count) {
            NSDictionary *beginDict = [self.model.bindStrArray objectAtIndex:i];
            NSString *beginStr = [beginDict getString:@"bind_str"];
            NSString *beginR = [self searchRangeWithTotalText:textView.attributedText.string WithKey:beginStr startLocation:beginLocation];
            if (beginR.length) {
                NSRange beginRange = NSRangeFromString(beginR);
                beginLocation = beginRange.location+beginRange.length;
            }
            
            NSDictionary *endDict = [self.model.bindStrArray objectAtIndex:end];
            NSString *endStr = [endDict getString:@"bind_str"];
            NSString *endR = [self searchRangeWithTotalText:textView.attributedText.string WithKey:endStr startLocation:beginLocation];
            NSString *submitRangeStr = [self blankRangeWithBeganRange:beginR endRange:endR];
            [changeArray addObject:submitRangeStr];
            NSString *submitStr = [self blankString:textView.attributedText.string beganRange:beginR endRange:endR];
            if (submitStr.length) {
              submitStr = [submitStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }else{
              submitStr = @"";
            }
            [submitArr addObject:submitStr];
        }
    }
    self.model.submitStrArray = [submitArr copy];
    if (changeArray.count) {
      self.model.blankRangeArray = changeArray;
    }
    
}

- (NSString *)searchRangeWithTotalText:(NSString *)totalText WithKey:(NSString *)searchKey startLocation:(NSUInteger)location{
    NSError *error = nil;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:searchKey options:NSRegularExpressionIgnoreMetacharacters | NSRegularExpressionDotMatchesLineSeparators error:&error];
    NSTextCheckingResult *matc = [regular firstMatchInString:totalText options:NSMatchingReportProgress range:NSMakeRange(location, totalText.length-location)];
    NSRange range = [matc range];
    NSString *returnRange = NSStringFromRange(range);
    return returnRange;
}

-(NSString *)blankString:(NSString *)totalStr beganRange:(NSString *)beginStr endRange:(NSString *)endStr{
    if (!beginStr.length || !endStr.length) {
        return nil;
    }
    NSRange beganRange = NSRangeFromString(beginStr);
    NSRange endRange = NSRangeFromString(endStr);
    if (endRange.location < beganRange.location + beganRange.length) {
        return nil;
    }
    NSString *string=[totalStr substringWithRange:NSMakeRange(beganRange.location+beganRange.length, endRange.location-(beganRange.location+beganRange.length))];
    return string;
}
- (NSString *)blankRangeWithBeganRange:(NSString *)beginStr endRange:(NSString *)endStr{
   if (!beginStr.length || !endStr.length) {
        return nil;
    }
    NSRange beganRange = NSRangeFromString(beginStr);
    NSRange endRange = NSRangeFromString(endStr);
    if (endRange.location < beganRange.location + beganRange.length) {
        return nil;
    }
    NSRange returnRange = NSMakeRange(beganRange.location+beganRange.length, endRange.location-(beganRange.location+beganRange.length));
    return NSStringFromRange(returnRange);
}

- (void)submitAction{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.model.submitStrArray options:0 error:&error];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    self.submitLabel.text = str;
}
#pragma mark -getter
- (FillTextView *)blankTextView{
    if (!_blankTextView) {
        _blankTextView=[[FillTextView alloc] init];
        _blankTextView.textColor = [UIColor blackColor];
        _blankTextView.font = [UIFont systemFontOfSize:16];
        _blankTextView.delegate=self;
        _blankTextView.returnKeyType=UIReturnKeyDone;
        _blankTextView.allowsCopyAttributedString = NO;
        _blankTextView.allowsPasteImage = NO;
        _blankTextView.allowsPasteAttributedString = NO;
        _blankTextView.showsVerticalScrollIndicator = NO;
        _blankTextView.showsHorizontalScrollIndicator = NO;
    }
    return _blankTextView;
}
- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _submitButton.backgroundColor = [UIColor orangeColor];
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (UILabel *)submitLabel{
    if (!_submitLabel) {
        _submitLabel = [[UILabel alloc] init];
        _submitLabel.textColor = [UIColor blueColor];
        _submitLabel.font = [UIFont systemFontOfSize:15];
        _submitLabel.textAlignment = NSTextAlignmentCenter;
        _submitLabel.numberOfLines = 0;
        _submitLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _submitLabel;
}
- (FillBlankModel *)model{
    if (!_model) {
        _model = [[FillBlankModel alloc] init];
    }
    return _model;
}
@end
