//
//  LKSMXCTabBarController.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger ,DCTabBarControllerType){
    DCTabBarControllerHome = 0, //首页
    DCTabBarControllerMediaList = 1,  //美媚榜
    DCTabBarControllerBeautyStore = 2, //美店
    DCTabBarControllerPerson = 3, //个人中心
};

@interface LKSMXCTabBarController : UITabBarController

/* 控制器type */
@property (assign , nonatomic)DCTabBarControllerType tabVcType;

@end
