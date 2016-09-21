//
//  WJThridViewController.m
//  WJSegmentedScrollViewDemo
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "WJThridViewController.h"
#import <Masonry/Masonry.h>

@interface WJThridViewController ()

@end

@implementation WJThridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.view.backgroundColor = [UIColor purpleColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"WJSegmentedScrollViewDemo \nWJThridViewController";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WJSegPageViewControllerSource
- (NSString*)segmentTitle {
    return @"the thrid";
}

- (UIView*)streachScrollView {
    return self.view;
}
@end
