//
//  ChangeLKSMXCPasswordViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/29.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "ChangeLKSMXCPasswordViewController.h"

@interface ChangeLKSMXCPasswordViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *odlPwdTF;


@property(nonatomic,strong) UITextField *newsPwdTF;

@end

@implementation ChangeLKSMXCPasswordViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (UITextField *)odlPwdTF{
    if (!_odlPwdTF) {
        _odlPwdTF = [[UITextField alloc]init];
        _odlPwdTF.borderStyle = UITextBorderStyleRoundedRect;
        _odlPwdTF.delegate = self;
        _odlPwdTF.textAlignment = NSTextAlignmentCenter;
        _odlPwdTF.secureTextEntry = YES;
        _odlPwdTF.placeholder = @"输入旧密码";
        _odlPwdTF.returnKeyType = UIReturnKeyDone;
    }
    return _odlPwdTF;
}
- (UITextField *)newsPwdTF{
    if (!_newsPwdTF) {
        _newsPwdTF = [[UITextField alloc]init];
        _newsPwdTF.borderStyle = UITextBorderStyleRoundedRect;
        _newsPwdTF.delegate = self;
        _newsPwdTF.textAlignment = NSTextAlignmentCenter;
        _newsPwdTF.secureTextEntry = YES;
        _newsPwdTF.placeholder = @"输入新密码";
        _newsPwdTF.returnKeyType = UIReturnKeyDone;
    }
    return _newsPwdTF;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addDefaultBackItem];
    [self setNavBarTitle:@"修改密码"];
    [self setRightItemTitle:@"完成"];
    [self.view addSubview:self.odlPwdTF];
    [self.view addSubview:self.newsPwdTF];
    
    [self.odlPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNavBar.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    [self.newsPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.odlPwdTF.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    RACSignal *oldSignal = self.odlPwdTF.rac_textSignal;
    RACSignal *newsSignal = self.newsPwdTF.rac_textSignal;
    RAC(self.rightItemBtn,enabled) = [RACSignal  combineLatest:@[oldSignal,newsSignal] reduce:^id _Nullable(NSString *old,NSString *news){
        return @(old.length > 0 && news.length > 0);
    }];
    [self.odlPwdTF becomeFirstResponder];
}
- (void)rightItemAction:(id)sender{
    [self LUCK_checkPassword];
}
- (BOOL)LUCK_checkPassword{
    if (self.isMainPwd) {
        if ([self.odlPwdTF.text isEqualToString:[LKSMXCUnit LUCK_getMainPassword]]) {
            if (self.newsPwdTF.text.length) {
                [LKSMXCUnit LUCK_setMainPassword:self.newsPwdTF.text];
                [SVProgressHUD showInfoWithStatus:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return YES;
            }
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"旧密码输入错误"];
            return NO;
        }
    }
    else{
        if ([self.odlPwdTF.text isEqualToString:[LKSMXCUnit LUCK_getFalsePassword]]) {
            if (self.newsPwdTF.text.length) {
                [LKSMXCUnit LUCK_setFalsePassword:self.newsPwdTF.text];
                [SVProgressHUD showInfoWithStatus:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return YES;
            }
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"旧密码输入错误"];
            return NO;
        }
    }
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.odlPwdTF) {
        [self.newsPwdTF becomeFirstResponder];
        return NO;
    }else{
        return [self LUCK_checkPassword];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
