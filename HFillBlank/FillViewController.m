//
//  FillViewController.m
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/26.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import "FillViewController.h"
#import "FillBlankView.h"
@interface FillViewController ()

@property (nonatomic, strong) FillBlankView *fillBlankView;

@end

@implementation FillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填空题";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fillBlankView];
    [self.fillBlankView testWithIsShow:self.isInputed];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.fillBlankView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+20, self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.navigationController.navigationBar.frame)-20);
}

- (FillBlankView *)fillBlankView{
    if (!_fillBlankView) {
        _fillBlankView = [[FillBlankView alloc] init];
    }
    return _fillBlankView;
}

@end
