//
//  Macros.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 Insect. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

#define kAUTOSCALE_WIDTH(width) (width) * ScreenW/375.00
#define kAUTOSCALE_HEIGHT(height) (height) * ScreenH/667.00

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;


/******************    TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"
/*****************  屏幕适配  ******************/
#define iphone6p (ScreenH == 763)
#define iphone6 (ScreenH == 667)
#define iphone5 (ScreenH == 568)
#define iphone4 (ScreenH == 480)

#define APP_VERSION                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

//全局背景色
// "8600FF"
#define DCBGColor RGB(134,0,255)

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"


#define TITLES @[@"发起聊天", @"添加好友", @"扫一扫"]
#define ICONS  @[@"mshop_message_gray",@"mshop_message_gray",@"mshop_message_gray"]


#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define KEYWINDOW  [UIApplication sharedApplication].keyWindow

#define UserInfoData [DCUserInfo findAll].lastObject

#define kMAIN_COLOR_GRAY            RGB(241,241,241)

//判断设备是否为iphoneX
#define DCIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


/*****************  蒲公英更新  ******************/
//获取当前版本号
#define BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
//获取当前版本的biuld
#define BIULD_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//获取当前设备的UDID
#define DIV_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#endif /* Macros_h */
