//
//  ViewController.m
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/26.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import "ViewController.h"
#import "FillViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listTableView];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.listTableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.navigationController.navigationBar.frame));
}
#pragma mark -UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
      cell.textLabel.text=@"填空题(无输入内容)";
    }else if(indexPath.row == 1){
      cell.textLabel.text=@"填空题(有输入内容)";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FillViewController *vc = [[FillViewController alloc] init];
    if (indexPath.row == 0) {
        vc.isInputed = NO;
    }else{
        vc.isInputed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.cellLayoutMarginsFollowReadableWidth = NO;
        if (@available(iOS 11.0, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _listTableView.estimatedRowHeight=0;
            _listTableView.estimatedSectionHeaderHeight=0;
            _listTableView.estimatedSectionFooterHeight=0;
        }
        _listTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _listTableView;
}
@end
