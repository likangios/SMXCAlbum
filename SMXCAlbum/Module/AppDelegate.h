//
//  AppDelegate.h
//  SecretAlbum
//
//  Created by perfay on 2018/10/22.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void)LUCK_setUpRootVC;

- (void)LUCK_showPasswordVC;

-(UIViewController *)getCurrentUIVC;
@end

