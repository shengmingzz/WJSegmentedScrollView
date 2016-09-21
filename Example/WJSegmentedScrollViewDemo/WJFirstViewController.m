//
//  WJFirstViewController.m
//  WJSegmentedScrollViewDemo
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "WJFirstViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface WJFirstViewController ()
@property (nonatomic,assign) NSInteger countCell;
@end

@implementation WJFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.countCell = 10;
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.mj_header = [[MJRefreshNormalHeader alloc] init];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView.mj_header setRefreshingBlock:^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        strongSelf.countCell = 10;
        [strongSelf.tableView reloadData];
    }];
    
    self.tableView.mj_footer = [[MJRefreshAutoNormalFooter alloc] init];
    [self.tableView.mj_footer setRefreshingBlock:^() {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_footer endRefreshing];
        strongSelf.countCell += 10;
        [strongSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [@"a" stringByAppendingString: @(indexPath.row).stringValue];
    return cell;
}
#pragma mark - WJSegPageViewControllerSource
- (NSString*)segmentTitle {
    return @"the first";
}
- (NSString *)segmentImage {
    return @"";
}
- (NSString *)segmentSelImage {
    return @"";
}
- (UIView*)streachScrollView {
    return self.tableView;
}
@end
