//
//  FixLKSMXCIconViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/29.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "FixLKSMXCIconViewController.h"

@interface FixLKSMXCIconViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *iconsDataArray;

@property(nonatomic,strong) NSArray *iconsKeyDataArray;

@end

@implementation FixLKSMXCIconViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDefaultBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBarTitle:@"伪装图标"];
    self.iconsDataArray = @[@"Icon-1-120",@"Icon-2-120",@"Icon-3-120"];
    self.iconsKeyDataArray = @[@"icon1",@"icon2",@"icon3"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.customNavBar.mas_bottom);
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.iconsDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.imageView.image = [UIImage imageNamed:self.iconsDataArray[indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.text = @"点选使用此图标";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (@available(iOS 10.3, *)) {
            if ([[UIApplication sharedApplication] supportsAlternateIcons]) {
                [[UIApplication sharedApplication] setAlternateIconName:self.iconsKeyDataArray[indexPath.row] completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"更换icon发送错误：%@",error);
                    }
                    else{
                        
                    }
                }];
            }
        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
