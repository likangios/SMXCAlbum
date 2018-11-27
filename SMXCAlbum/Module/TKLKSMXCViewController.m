//
//  TKLKSMXCViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/29.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "TKLKSMXCViewController.h"
#import <WebKit/WebKit.h>
@interface TKLKSMXCViewController ()
@property(nonatomic,strong) WKWebView *custom_WebView;

@end

@implementation TKLKSMXCViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (WKWebView *)custom_WebView{
    if (!_custom_WebView) {
        _custom_WebView = [[WKWebView alloc]init];
    }
    return _custom_WebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self addDefaultBackItem];
    [self setNavBarTitle:@"隐私条款"];
    [self.view addSubview:self.custom_WebView];
    [self.custom_WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.customNavBar.mas_bottom);
    }];
    [self.custom_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jiakao.xianwan.com/driver/index/policy?id=4"]]];
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
