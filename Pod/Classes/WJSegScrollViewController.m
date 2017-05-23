//
//  WJSegScrollViewController.m
//  WJSegmentedScrollViewDemo
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "WJSegScrollViewController.h"
#import "Masonry.h"

@interface WJSegScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *segScrollView;
@property (nonatomic,strong) UIView *segContentView;

@property (nonatomic,strong) UIScrollView *ctrlsScrollView;
@property (nonatomic,strong) UIView *ctrlsContentView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic,strong) NSMutableArray *viewObservers;
@property (nonatomic,assign) BOOL observing;

@end

@implementation WJSegScrollViewController

@synthesize controllers = _controllers;

- (void)dealloc {
    @try {
        if ([_segScrollView observationInfo]) {
            [_segScrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
        for (UIViewController<WJSegPageViewControllerSource> *vc in self.controllers) {
            UIView *view = [vc streachScrollView];
            if (view) {
                if ([view observationInfo]) {
                    [view removeObserver:self forKeyPath:@"contentOffset"];
                }
            } else {
                if ([vc.view observationInfo]) {
                    [vc.view removeObserver:self forKeyPath:@"contentOffset"];
                }
            }
            
        }
    }
    @catch (NSException *exception) {
        //        NSLog(@"%s,%d,%@",__func__,__LINE__,exception);
    }
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.observing = YES;
        self.topSpacing = 64;
        self.bottomSpacing = 0;
    }
    return self;
}

- (instancetype)initWithControllerArrays:(NSArray*)controllers {
    self = [super init];
    if (self) {
        self.observing = YES;
        self.topSpacing = 64;
        self.bottomSpacing = 0;
        [self.controllers addObjectsFromArray:controllers];
    }
    return self;
}
/*
 * 外部scrollview segScrollView上线滑动,内容高度header高度 + segment高度 + 加上视图控制器高度
 * 底部scrollview ctrlsScrollView左右滑动,内容高度为视图控制器高度
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    float height = [UIScreen mainScreen].bounds.size.height + self.headerViewHeight - self.topSpacing - self.bottomSpacing - self.marginTopSpacing;
    float width = [UIScreen mainScreen].bounds.size.width;
    
    [self.view addSubview:self.segScrollView];
    [self.segScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.segScrollView addSubview:self.segContentView];
    [self.segContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.segScrollView);
        make.width.equalTo(self.segScrollView);
        make.height.equalTo(@(height));
    }];
    
    [self.segContentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.segContentView);
        make.height.equalTo(@(self.headerViewHeight));
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *selImages = [NSMutableArray array];
    for (UIViewController<WJSegPageViewControllerSource> *controller in self.controllers) {
        if ([controller respondsToSelector:@selector(segmentTitle)]) {
            [titles addObject:[controller segmentTitle]?[controller segmentTitle]:@""];
        } else {
            [titles addObject:@""];
        }
        if ([controller respondsToSelector:@selector(segmentImage)]) {
            [images addObject:[controller segmentImage]?[controller segmentImage]:@""];
        } else {
            [images addObject:@""];
        }
        if ([controller respondsToSelector:@selector(segmentSelImage)]) {
            [selImages addObject:[controller segmentSelImage]?[controller segmentSelImage]:@""];
        } else {
            [selImages addObject:@""];
        }
    }
    if (self.segmentType == HMSegmentedControlTypeImages) {
        self.segmentControl = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selImages];
    } else if (self.segmentType == HMSegmentedControlTypeTextImages) {
        self.segmentControl = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selImages titlesForSections:titles];
    } else {
        self.segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    }
    
    [self.segmentControl addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segScrollView addSubview:self.segmentControl];
    self.segmentControl.backgroundColor = [UIColor grayColor];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.segContentView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@(self.segmentHeight));
    }];
    
    [self.segContentView addSubview:self.ctrlsScrollView];
    [self.ctrlsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_segContentView);
        make.top.equalTo(self.headerView.mas_bottom).offset(self.segmentHeight);
        make.bottom.equalTo(self.segContentView);
    }];
    
    [self.ctrlsScrollView addSubview:self.ctrlsContentView];
    [self.ctrlsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.ctrlsScrollView);
        make.height.equalTo(self.ctrlsScrollView);
        make.width.equalTo(@(width*self.controllers.count));
    }];
    
    UIView *lastView = nil;
    for (UIViewController<WJSegPageViewControllerSource> *vc in self.controllers) {
        [self addChildViewController:vc];
        [self.ctrlsContentView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.ctrlsContentView);
            make.left.equalTo(lastView ? lastView.mas_right : self.ctrlsContentView);
            make.width.equalTo(@(width));
        }];
        [vc didMoveToParentViewController:self];
        
        if ([vc respondsToSelector:@selector(streachScrollView)]) {
            [[vc streachScrollView] addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        } else {
            [vc.view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        lastView = vc.view;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addHeaderView:(UIView*)view {
    for (UIView *view in self.headerView.subviews) {
        [view removeFromSuperview];
    }
    [self.headerView addSubview:view];
}

-(void)setTitles:(NSArray*)titles {
    [self.segmentControl setSectionTitles:titles];
    [self.segmentControl setNeedsDisplay];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.ctrlsScrollView) {
        NSInteger pageIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.segmentControl.selectedSegmentIndex = pageIndex;
        if (self.delegate && [self.delegate respondsToSelector:@selector(segScrollViewVC:didSelectIndex:)]) {
            [self.delegate segScrollViewVC:self didSelectIndex:pageIndex];
        }
    }
}

#pragma mark - IOButlet
- (void)segmentControlDidChangedValue:(id)sender {
    NSInteger selectIndex = self.segmentControl.selectedSegmentIndex;
    [self.ctrlsScrollView setContentOffset:CGPointMake(selectIndex * CGRectGetWidth(self.ctrlsScrollView.frame), 0) animated:NO];
    //    [self setChildViewControllerWithCurrentIndex:selectIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(segScrollViewVC:didSelectIndex:)]) {
        [self.delegate segScrollViewVC:self didSelectIndex:selectIndex];
    }
}

- (UIScrollView *)scrollViewInPageController:(UIViewController<WJSegPageViewControllerSource> *)controller {
    if ([controller respondsToSelector:@selector(streachScrollView)]) {
        return [controller streachScrollView];
    } else if ([controller.view isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)controller.view;
    } else {
        return nil;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (!self.observing) {
        return;
    }
    UIScrollView *scrollView = (UIScrollView*)object;
    if (scrollView == nil) {
        return;
    }
    
    float margin = self.segScrollView.contentOffset.y - self.headerViewHeight;
    if (margin < 0 && ABS(margin) <= self.marginTopSpacing) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hasScrollAtTopForSegScrollViewVC:)]) {
            [self.delegate hasScrollAtTopForSegScrollViewVC:self];
        }
    } else if (ABS(margin) > self.marginTopSpacing+20){
        if (self.delegate && [self.delegate respondsToSelector:@selector(hasScrollLeaveTopForSegScrollViewVC:)]) {
            [self.delegate hasScrollLeaveTopForSegScrollViewVC:self];
        }
    }
    
    if (scrollView == self.segScrollView) {
        if (self.segScrollView.contentOffset.y > (self.headerViewHeight-self.marginTopSpacing)) {
            self.segScrollView.contentOffset = CGPointMake(0, self.headerViewHeight-self.marginTopSpacing);
        }
        return;
    }
    CGPoint new = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGPoint old = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGFloat diff = old.y - new.y;
    
    /*float offsety = self.segScrollView.contentOffset.y - self.headerViewHeight - self.segmentHeight;
     float height = [UIScreen mainScreen].bounds.size.height  - self.topSpacing - self.bottomSpacing;
     float useHeight = height - offsety;
     if (useHeight > (height-self.headerViewHeight - self.segmentHeight)) {
     useHeight = height-self.headerViewHeight - self.segmentHeight;
     }
     if (useHeight < 0) {
     useHeight = 0;
     }*/
    
    float offsety = self.segScrollView.contentOffset.y - self.headerViewHeight;
    float height = [UIScreen mainScreen].bounds.size.height  - self.topSpacing - self.bottomSpacing - self.segmentHeight - self.marginTopSpacing;
    float useHeight = height - ABS(offsety)/*offsety*/;
    if (useHeight < (height-self.headerViewHeight - self.segmentHeight)) {
        useHeight = height-self.headerViewHeight - self.segmentHeight;
    }
    if (useHeight > height) {
        useHeight = height ;
    }
    if (useHeight < 0) {
        useHeight = 0;
    }
    if (self.segScrollView.contentOffset.y > (self.headerViewHeight-self.marginTopSpacing)) {
        self.segScrollView.contentOffset = CGPointMake(0, self.headerViewHeight-self.marginTopSpacing);
    }
    /*
     [self.ctrlsScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
     make.height.equalTo(@(useHeight));
     }];*/
    
    if (diff > 0.0) {
        [self handleScrollUp:scrollView change:diff oldPosition:old];
    } else {
        [self handleScrollDown:scrollView change:diff oldPosition:old];
    }
}
//up to down
- (void)handleScrollUp:(UIScrollView*)scrollView change:(CGFloat)change oldPosition:(CGPoint)oldPosition {
    if (scrollView.contentOffset.y < 0.0) {
        if (self.segScrollView.contentOffset.y >= 0) {
            CGFloat yPos = self.segScrollView.contentOffset.y - change;
            CGFloat newyPos = yPos < 0 ? 0 : yPos;
            CGPoint updatedPos = CGPointMake(self.segScrollView.contentOffset.x, newyPos);
            if (self.segScrollView.contentOffset.y == 0) {
                [self setContentOffset:self.segScrollView point:updatedPos];
            } else {
                [self setContentOffset:self.segScrollView point:updatedPos];
                [self setContentOffset:scrollView point:oldPosition];
            }
            
        }
    }
}
// down to up
- (void)handleScrollDown:(UIScrollView*)scrollView change:(CGFloat)change oldPosition:(CGPoint)oldPosition {
    CGFloat offset = self.headerViewHeight - self.headerViewOffsetHeight-self.marginTopSpacing;
    if (self.segScrollView.contentOffset.y < offset) {
        if (scrollView.contentOffset.y >= 0.0) {
            CGFloat yPos = self.segScrollView.contentOffset.y - change;
            yPos = yPos > offset ? offset : yPos;
            CGPoint updatedPos = CGPointMake(self.segScrollView.contentOffset.x, yPos);
            
            if (oldPosition.y <= 0) {
                [self setContentOffset:scrollView point:CGPointMake(self.segScrollView.contentOffset.x, 0)];
                if (oldPosition.y < 0 && self.segScrollView.contentOffset.y == 0) {
                    
                } else {
                    [self setContentOffset:self.segScrollView point:updatedPos];
                }
            } else {
                [self setContentOffset:scrollView point:oldPosition];
                [self setContentOffset:self.segScrollView point:updatedPos];
            }
        }
    }
}

- (void)setContentOffset:(UIScrollView*)scrollView point:(CGPoint)point {
    self.observing = false;
    scrollView.contentOffset = point;
    self.observing = true;
}

#pragma mark - setter
- (void)setHeaderViewHeight:(CGFloat)headerViewHeight {
    _headerViewHeight = headerViewHeight;
    if ([self isViewLoaded]) {
        float height = [UIScreen mainScreen].bounds.size.height + _headerViewHeight - self.topSpacing - self.bottomSpacing;
        
        [_segContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
        
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.headerViewHeight));
        }];
    }
}

- (void)setControllers:(NSMutableArray *)controllers {
    _controllers = controllers;
    if ([self isViewLoaded]) {
        
    }
}
#pragma mark - getter

- (NSMutableArray *)viewObservers {
    if (!_viewObservers) {
        _viewObservers = [@[] mutableCopy];
    }
    return _viewObservers;
}

- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [@[] mutableCopy];
    }
    return _controllers;
}

- (UIScrollView *)segScrollView {
    if (!_segScrollView ) {
        _segScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _segScrollView.showsHorizontalScrollIndicator = NO;
        _segScrollView.showsVerticalScrollIndicator = NO;
        [_segScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return _segScrollView;
}

- (UIView *)segContentView {
    if (!_segContentView ) {
        _segContentView = [UIView new];
    }
    return _segContentView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIScrollView *)ctrlsScrollView {
    if (!_ctrlsScrollView) {
        _ctrlsScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _ctrlsScrollView.pagingEnabled = YES;
        _ctrlsScrollView.delegate = self;
        _ctrlsScrollView.showsVerticalScrollIndicator = NO;
        _ctrlsScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _ctrlsScrollView;
}

- (UIView *)ctrlsContentView {
    if (!_ctrlsContentView) {
        _ctrlsContentView = [UIView new];
    }
    return _ctrlsContentView;
}
@end
