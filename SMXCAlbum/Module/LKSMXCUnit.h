//
//  LKSMXCUnit.h
//  SecretAlbum
//
//  Created by perfay on 2018/10/24.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    type_temp = 1,//未设置密码
    type_guest,//伪密码登录
    type_admin,//主密码登录
}loginType;
@interface LKSMXCUnit : NSObject
//获取相机是否可用
+ (BOOL)LUCK_getCameraAuthorizationSatusIsAvailable;
//读取缓存图片
+ (UIImage *)LUCK_getCacheImageWithKey:(NSString *)key;
//抓拍
+ (void)LUCK_setZhuaPaiEnabel:(BOOL)enable;
+ (BOOL)LUCK_getZhuaPaiEnable;
//设置主密码
+ (void)LUCK_setMainPasswordEnabel:(BOOL)enable;
+ (BOOL)LUCK_getMainPasswordEnable;
+ (void)LUCK_setMainPassword:(NSString *)pwd;
+ (NSString *)LUCK_getMainPassword;
//设置伪密码
+ (void)LUCK_setFalsePasswordEnabel:(BOOL)enable;
+ (BOOL)LUCK_getFalsePasswordEnable;
+ (void)LUCK_setFalsePassword:(NSString *)pwd;
+ (NSString *)LUCK_getFalsePassword;

+ (loginType)LUCK_getUserType;
+ (void)LUCK_setUserType:(loginType)type;
@end
