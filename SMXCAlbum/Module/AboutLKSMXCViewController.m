//
//  AboutLKSMXCViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/29.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "AboutLKSMXCViewController.h"

@interface AboutLKSMXCViewController ()

@property(nonatomic,strong) UIImageView *iconImageView;

@property(nonatomic,strong) UILabel *versionLb;

@property(nonatomic,strong) UILabel *contentLb;

@end

@implementation AboutLKSMXCViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (UIImageView *)iconImageView{
    if(!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.backgroundColor = [UIColor randomColor];
    }
    return _iconImageView;
}
- (UILabel *)versionLb{
    if (!_versionLb) {
        _versionLb = [UILabel new];
        _versionLb.textColor = [UIColor colorWithHexString:NEDecodeOcString(MOyyvsszTECcRigl,sizeof(MOyyvsszTECcRigl))];
        _versionLb.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLb;
}
- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [UILabel new];
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.textColor = [UIColor colorWithHexString:NEDecodeOcString(MOyyvsszTECcRigl,sizeof(MOyyvsszTECcRigl))];
        _contentLb.textAlignment = NSTextAlignmentLeft;
        _contentLb.numberOfLines = 0;
        _contentLb.text = @"这是一款离线应用，所有数据都保存在本地不会上传到任何服务器，这是最安全的保存方式。因此如果你忘记了密码，我们也无法帮助你,请提前备份密码。";
    }
    return _contentLb;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addDefaultBackItem];
    [self setNavBarTitle:@"关于"];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.versionLb];
    [self.view addSubview:self.contentLb];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(60);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.customNavBar.mas_bottom).offset(80);
    }];
    [self.versionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-80);
    }];
    self.versionLb.text = [NSString stringWithFormat:@"当前版本：%@",APP_VERSION];
    self.iconImageView.image = [UIImage imageNamed:NEDecodeOcString(QcfLtqOUMnYmRoBD,sizeof(QcfLtqOUMnYmRoBD))];
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
