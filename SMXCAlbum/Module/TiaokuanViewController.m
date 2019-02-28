//
//  TiaokuanViewController.m
//  ydd_mj_zyt
//
//  Created by perfay on 2018/10/16.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "TiaokuanViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import <AFNetworking.h>
@interface TiaokuanViewController ()<UINavigationBarDelegate,UIScrollViewDelegate,WKNavigationDelegate>

@property(nonatomic,strong) WKWebView *webView;

@property(nonatomic,strong) UIButton *confirmButton;


@end

@implementation TiaokuanViewController

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"阅读并同意隐私政策" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 20;
        _confirmButton.backgroundColor = [UIColor purpleColor];
    }
    return _confirmButton;
}
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.allowsLinkPreview = false;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.confirmButton];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    NSString *url = @"https://www.jianshu.com/p/63a57cdf47c1";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:

                break;
            case AFNetworkReachabilityStatusNotReachable:

                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self.
                 webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //顶部 下载APP
    [webView evaluateJavaScript:@"document.getElementsByClassName('header-wrap')[0].style.display = 'none'" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
    //底部打开APP
    [webView evaluateJavaScript:@"document.getElementsByClassName('footer-wrap')[0].style.display = 'none'" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
    //底部 登录 打开 热门
    [webView evaluateJavaScript:@"document.getElementsByClassName('panel')[0].style.display = 'none'" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
    //顶部打卡APP
    [webView evaluateJavaScript:@"document.getElementsByClassName('app-open')[0].style.display = 'none'" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
    //中部 打开APP阅读
    [webView evaluateJavaScript:@"document.getElementsByClassName('open-app-btn')[0].style.display = 'none'" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
    //个人信息
    [webView evaluateJavaScript:@"document.getElementsByClassName('article-info')[0].style.display = 'none'" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
    //    [SVProgressHUD dismiss];
    
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
