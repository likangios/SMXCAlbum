//
//  LKSMXCBaseSetViewController.h
//  CDDStoreDemo
//
//  Created by dashen on 2017/12/1.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
static NSInteger navBarH = 64;

@interface LKSMXCBaseSetViewController : UIViewController

@property (nonatomic,strong) UIButton *leftItemBtn;

@property (nonatomic,strong) UIButton *rightItemBtn;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *backTipLabel;

@property (nonatomic,strong) UIView  *customNavBar;

@property (nonatomic,assign) CGFloat statusBarHeight;

- (void)adjustStatusBar;

- (void)hidenBottomLine;

- (void)hidenNavBar;

- (void)addDefaultBackItem;

- (void)setNavBarTitle:(NSString *)title;

- (void)setLeftItemTitle:(NSString *)title;

- (void)setLeftItemImage:(NSString *)imageName;

- (void)setRightItemTitle:(NSString *)title;

- (void)setRightItemImage:(NSString *)imageName;

- (void)leftItemAction:(id)sender;

- (void)rightItemAction:(id)sender;

- (BOOL) IsFirstTimeDisplay;

@end


