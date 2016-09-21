//
//  WJSecondViewController.m
//  WJSegmentedScrollViewDemo
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "WJSecondViewController.h"

@interface WJSecondViewController ()

@end

@implementation WJSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [@"b" stringByAppendingString: @(indexPath.row).stringValue];
    return cell;
}
#pragma mark - WJSegPageViewControllerSource
- (NSString*)segmentTitle {
    return @"the second";
}

- (UIView*)streachScrollView {
    return self.tableView;
}

@end
