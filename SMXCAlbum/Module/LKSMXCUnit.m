//
//  LKSMXCUnit.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/24.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "LKSMXCUnit.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
@implementation LKSMXCUnit
+ (BOOL)LUCK_getCameraAuthorizationSatusIsAvailable{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限 做一个友好的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        [alert addAction:cancel];
        [alert addAction:confirm];
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *vc = [dele getCurrentUIVC];
        [vc presentViewController:alert animated:YES completion:NULL];
        return NO;
    }
    return YES;
}
+ (UIImage *)LUCK_getCacheImageWithKey:(NSString *)key{
    if (!key.length) {
        return [UIImage imageNamed:NEDecodeOcString(QXoybhZCsTDlVxbw,sizeof(QXoybhZCsTDlVxbw))];
    }
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if (cacheImage == nil) {
        cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    }
    if (cacheImage == nil) {
        cacheImage = [UIImage imageNamed:NEDecodeOcString(QXoybhZCsTDlVxbw,sizeof(QXoybhZCsTDlVxbw))];
    }
    return cacheImage;
}
//抓拍
+ (void)LUCK_setZhuaPaiEnabel:(BOOL)enable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(enable) forKey:NEDecodeOcString(UCcUTXuZKKJECTix,sizeof(UCcUTXuZKKJECTix))];
    [defaults synchronize];
}
+ (BOOL)LUCK_getZhuaPaiEnable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enable = [defaults objectForKey:NEDecodeOcString(UCcUTXuZKKJECTix,sizeof(UCcUTXuZKKJECTix))];
    return enable.boolValue;
}
//主密码
+ (void)LUCK_setMainPasswordEnabel:(BOOL)enable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(enable) forKey:NEDecodeOcString(otcHRUKmPqroIilq,sizeof(otcHRUKmPqroIilq))];
    [defaults synchronize];
}
+ (BOOL)LUCK_getMainPasswordEnable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enable = [defaults objectForKey:NEDecodeOcString(otcHRUKmPqroIilq,sizeof(otcHRUKmPqroIilq))];
    return enable.boolValue;
}
+ (void)LUCK_setMainPassword:(NSString *)pwd{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pwd forKey:NEDecodeOcString(jXViVepRaNPzSbdG,sizeof(jXViVepRaNPzSbdG))];
    [defaults synchronize];
}
+ (NSString *)LUCK_getMainPassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:NEDecodeOcString(jXViVepRaNPzSbdG,sizeof(jXViVepRaNPzSbdG))];
}
//设置伪密码
+ (void)LUCK_setFalsePasswordEnabel:(BOOL)enable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(enable) forKey:NEDecodeOcString(obwleeAfuXiIYXIZ,sizeof(obwleeAfuXiIYXIZ))];
    [defaults synchronize];
}
+ (BOOL)LUCK_getFalsePasswordEnable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enable = [defaults objectForKey:NEDecodeOcString(obwleeAfuXiIYXIZ,sizeof(obwleeAfuXiIYXIZ))];
    return enable.boolValue;
}
+ (void)LUCK_setFalsePassword:(NSString *)pwd{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pwd forKey:NEDecodeOcString(DQHdhPBiRhcnfgLg,sizeof(DQHdhPBiRhcnfgLg))];
    [defaults synchronize];
}
+ (NSString *)LUCK_getFalsePassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:NEDecodeOcString(DQHdhPBiRhcnfgLg,sizeof(DQHdhPBiRhcnfgLg))];
}
//用户类型
+ (loginType)LUCK_getUserType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enable = [defaults objectForKey:NEDecodeOcString(OWeFSeldcMHqYvbZ,sizeof(OWeFSeldcMHqYvbZ))];
    if (!enable) {
        return  type_temp;
    }
    else{
        return enable.integerValue;
    }
}
+ (void)LUCK_setUserType:(loginType)type{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(type) forKey:NEDecodeOcString(OWeFSeldcMHqYvbZ,sizeof(OWeFSeldcMHqYvbZ))];
    [defaults synchronize];
}
@end
