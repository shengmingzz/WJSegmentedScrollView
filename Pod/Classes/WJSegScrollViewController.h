//
//  WJSegScrollViewController.h
//  WJSegmentedScrollViewDemo
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

@protocol WJSegPageViewControllerSource <NSObject>

@optional
- (NSString *)segmentTitle;
- (NSString *)segmentImage;
- (NSString *)segmentSelImage;
- (UIScrollView *)streachScrollView;
@end

@class WJSegScrollViewController;

@protocol WJSegPageViewControllerDelegate <NSObject>

@optional
- (void)segScrollViewVC:(WJSegScrollViewController*)scrollViewVC didSelectIndex:(NSInteger)index;
@end

@interface WJSegScrollViewController : UIViewController

/**
 *  init method
 */
- (instancetype)initWithControllerArrays:(NSArray*)controllers;

@property (nonatomic,weak) id<WJSegPageViewControllerDelegate> delegate;

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic,assign) CGFloat headerViewHeight;
@property (nonatomic,assign) CGFloat headerViewOffsetHeight;

@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, readonly) UIView *headerView;
@property (nonatomic, readonly) HMSegmentedControl *segmentControl;

@property (nonatomic,assign ) HMSegmentedControlType segmentType;
/**
 *  top spacing ,default is 64
 */
@property (nonatomic,assign) float topSpacing;
/**
 *  bottom spacing ,default is 0
 */
@property (nonatomic,assign) float bottomSpacing;

- (void)addHeaderView:(UIView*)view;
@end
