//
//  ViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/22.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputPassword) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)inputPassword{
    PaLKSMXCsswordViewController *pwd = [[PaLKSMXCsswordViewController alloc]init];
    [self presentViewController:pwd animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
