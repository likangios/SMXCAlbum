//
//  LKSMXCTabBarController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "LKSMXCTabBarController.h"
#import "TiaokuanViewController.h"
#import "AlbumLKSMXCViewController.h"
#import "MineLKSMXCViewController.h"
// Controllers
#import "LKNavigationController.h"
#import "PaLKSMXCsswordViewController.h"
#import "AppDelegate.h"
// Models

// Views
// Vendors

// Categories

// Others

@interface LKSMXCTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;

@property(nonatomic,assign) NSInteger  firstDisplay;


@end

@implementation LKSMXCTabBarController

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    
    return _tabBarItems;
}
#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated {
    self.firstDisplay ++;
    [super viewWillAppear:animated];
    NSString *first =  [[NSUserDefaults standardUserDefaults] valueForKey:NEDecodeOcString(eAvzPRZmPaYDjppa,sizeof(eAvzPRZmPaYDjppa))];
    if (![first isEqualToString:NEDecodeOcString(nyoRZBfWDXvtTxGE,sizeof(nyoRZBfWDXvtTxGE))]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TiaokuanViewController *tiaok = [[TiaokuanViewController alloc]init];
            [self presentViewController:tiaok animated:YES completion:NULL];
        });
    }

}
#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstDisplay = 0;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self addDcChildViewContorller];
    self.selectedIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputPassword) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)inputPassword{
    if ([LKSMXCUnit LUCK_getMainPasswordEnable]) {
        PaLKSMXCsswordViewController *pwd = [[PaLKSMXCsswordViewController alloc]init];
        [self presentViewController:pwd animated:NO completion:NULL];
    }
}
#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    NSArray *childArray = @[
                            @{MallClassKey  : NEDecodeOcString(lUiuAmdbLNWvGwzg,sizeof(lUiuAmdbLNWvGwzg)),
                              MallTitleKey  : @"私密",
                              MallImgKey    : NEDecodeOcString(UWIvoClbhBaKgdXL,sizeof(UWIvoClbhBaKgdXL)),
                              MallSelImgKey : NEDecodeOcString(UWIvoClbhBaKgdXL,sizeof(UWIvoClbhBaKgdXL))},
                            
                            @{MallClassKey  : NEDecodeOcString(PqPVpSNpspqifCVl,sizeof(PqPVpSNpspqifCVl)),
                              MallTitleKey  : @"设置",
                              MallImgKey    : NEDecodeOcString(AtcaTVnyRbNVplAK,sizeof(AtcaTVnyRbNVplAK)),
                              MallSelImgKey : NEDecodeOcString(AtcaTVnyRbNVplAK,sizeof(AtcaTVnyRbNVplAK))}
                            ];
    self.tabBar.tintColor = DCBGColor;
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        LKNavigationController *nav = [[LKNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[MallTitleKey];
        item.image = [UIImage imageNamed:dict[MallImgKey]];
//        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:DCBGColor} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:NEDecodeOcString(ISiYWwbYtliheHeu,sizeof(ISiYWwbYtliheHeu))]} forState:UIControlStateNormal];
        [self addChildViewController:nav];
        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}

/*
#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
    if ([self.childViewControllers.firstObject isEqual:viewController]) { //根据tabBar的内存地址找到美信发通知jump
        [[NSNotificationCenter defaultCenter] postNotificationName:NEDecodeOcString(ZCyioeOWEkHqKtyi,sizeof(ZCyioeOWEkHqKtyi)) object:nil];
    }

    
}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];

    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(NEDecodeOcString(zcEkFNryOdTCxjsa,sizeof(zcEkFNryOdTCxjsa)))]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(NEDecodeOcString(pvNJaHQLUhIEhZSb,sizeof(pvNJaHQLUhIEhZSb)))]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = NEDecodeOcString(NKnMUWJQwvYZCJBR,sizeof(NKnMUWJQwvYZCJBR));
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
}


#pragma mark - 更新badgeView
- (void)updateBadgeValue
{
}

#pragma mark - 只要监听的item的属性一有新值，就会调用该方法重新给属性赋值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
   
}


#pragma mark - 移除通知
- (void)dealloc {
    [_item removeObserver:self forKeyPath:NEDecodeOcString(GAiLjaCZCEohdfhC,sizeof(GAiLjaCZCEohdfhC))];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}
*/

@end
