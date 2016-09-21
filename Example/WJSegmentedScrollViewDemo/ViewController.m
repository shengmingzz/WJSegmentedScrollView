//
//  ViewController.m
//  WJSegmentedScrollViewDemo
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ViewController.h"

#import <Masonry/Masonry.h>

#import "WJFirstViewController.h"
#import "WJSecondViewController.h"
#import "WJThridViewController.h"
#import "WJHeaderViewController.h"

#import "WJSegScrollViewController.h"

@interface ViewController ()
@property (nonatomic,strong) WJSegScrollViewController *segmentedViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =  @"WJSegmentedScrollViewDemo";

    WJFirstViewController *firstVC = [WJFirstViewController new];
    WJSecondViewController *secondVC = [WJSecondViewController new];
    WJThridViewController *thridVC = [WJThridViewController new];
    
    self.segmentedViewController = [[WJSegScrollViewController alloc] initWithControllerArrays:@[firstVC,secondVC,thridVC]];
    self.segmentedViewController.segmentHeight = 44;
    self.segmentedViewController.headerViewHeight = 250;
    self.segmentedViewController.headerViewOffsetHeight = 0;
    
    [self addChildViewController:self.segmentedViewController];
    [self.view addSubview:self.segmentedViewController.view];
    self.segmentedViewController.view.frame = self.view.bounds;
    [self.segmentedViewController didMoveToParentViewController:self];
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"Michael_Jordan"];
    [self.segmentedViewController addHeaderView:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgView.superview);
    }];
    
    self.segmentedViewController.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedViewController.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedViewController.segmentControl.backgroundColor = [UIColor colorWithRed:0xf0/255. green:0xf0/255. blue:0xf0/255. alpha:1.];
    self.segmentedViewController.segmentControl.selectionIndicatorColor = [UIColor colorWithRed:0x36/255. green:0xa6/255. blue:0xfa/255. alpha:1];
    self.segmentedViewController.segmentControl.selectionIndicatorHeight = 3;
    self.segmentedViewController.segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0x66/255. green:0x66/255. blue:0x66/255. alpha:1],
                                                              NSFontAttributeName: [UIFont systemFontOfSize:14]};
    self.segmentedViewController.segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0x36/255. green:0xa6/255. blue:0xfa/255. alpha:1],
                                                                      NSFontAttributeName: [UIFont systemFontOfSize:16]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(modifyHeaderHeight:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modifyHeaderHeight:(id)seder {
    if (self.segmentedViewController.headerViewHeight > 200) {
        self.segmentedViewController.headerViewHeight = 200;
    } else {
        self.segmentedViewController.headerViewHeight = 250;
    }
}

- (WJSegScrollViewController *)segmentedViewController {
    if (!_segmentedViewController) {
        _segmentedViewController = [[WJSegScrollViewController alloc] init];
    }
    return _segmentedViewController;
}

@end
