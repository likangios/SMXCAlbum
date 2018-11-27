//
//  MineLKSMXCViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/22.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "MineLKSMXCViewController.h"
#import "MineLKSMXCTableViewCell.h"
#import "ChangeLKSMXCPasswordViewController.h"
#import "FixLKSMXCIconViewController.h"
#import "AboutLKSMXCViewController.h"
#import "TKLKSMXCViewController.h"
#import "LocalLKSMXCDataManager.h"
#import <AVFoundation/AVFoundation.h>
@interface MineLKSMXCViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *sectionTitlesData;

@property(nonatomic,strong) NSArray *rowTitlesData;

@end

@implementation MineLKSMXCViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
        [_tableView registerClass:[MineLKSMXCTableViewCell class] forCellReuseIdentifier:@"MineLKSMXCTableViewCell"];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([LKSMXCUnit LUCK_getUserType] == type_guest) {
        self.sectionTitlesData = @[@"通用",@"关于"];
        self.rowTitlesData = @[@[@"修改密码"],@[@"关于",@"隐私条款"]];
    }
    else{
        self.sectionTitlesData = @[@"VIP",@"通用",@"高级",@"关于"];
        self.rowTitlesData = @[@[@"购买VIP去除广告",@"恢复购买"],@[@"主密码",@"修改主密码",@"清除数据"],@[@"伪密码",@"修改伪密码",@"伪装图标",@"输错密码抓拍"],@[@"关于",@"隐私条款"]];
    }
    [self.tableView reloadData];
}
- (UIImage *)LUCK_getImageNameWithTitle:(NSString *)title{
    NSDictionary *dic =@{
                         @"主密码":@"mainPwd",
                         @"修改主密码":@"xiugaipwd",
                         @"清除数据":@"cleanAll",
                         @"伪密码":@"falsePwd",
                         @"修改伪密码":@"xiugaipwd1",
                         @"伪装图标":@"weizhuang",
                         @"关于":@"about",
                         @"隐私条款":@"tiaokaun",
                         @"密码":@"mainPwd",
                         @"修改密码":@"xiugaipwd",
                         @"购买VIP去除广告":@"vip",
                         @"恢复购买":@"huifu",
                         @"输错密码抓拍":@"zhuapai"
                         };
    UIImage *name = [UIImage imageNamed:dic[title]];
    return name;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarTitle:@"设置"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNavBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.rowTitlesData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *row = self.rowTitlesData[section];
    return row.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitlesData[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineLKSMXCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineLKSMXCTableViewCell"];
    NSString *title = self.rowTitlesData[indexPath.section][indexPath.row];
    cell.titlelabel.text = title;
    cell.IconImageV.image = [self LUCK_getImageNameWithTitle:title];
    cell.showAccessory = YES;
    cell.enableSwitchVC.hidden = YES;
    if ([title isEqualToString:@"主密码"]||[title isEqualToString:@"密码"]||[title isEqualToString:@"伪密码"]||[title isEqualToString:@"输错密码抓拍"]) {
        cell.showAccessory = NO;
        cell.enableSwitchVC.hidden = NO;
        if ([title isEqualToString:@"主密码"]) {
            cell.enableSwitchVC.on = [LKSMXCUnit LUCK_getMainPasswordEnable];
        }
        else if ([title isEqualToString:@"伪密码"]) {
            cell.enableSwitchVC.on = [LKSMXCUnit LUCK_getFalsePasswordEnable];
        }
        else if ([title isEqualToString:@"输错密码抓拍"]) {
            cell.enableSwitchVC.on = [LKSMXCUnit LUCK_getZhuaPaiEnable];
        }
    }
    [[[cell.enableSwitchVC rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        MineLKSMXCTableViewCell *supCell =  (MineLKSMXCTableViewCell *)x.superview.superview;
        if ([supCell.titlelabel.text isEqualToString:@"主密码"]) {
            [self changeMainPwdState];
        }
        else if ([supCell.titlelabel.text isEqualToString:@"伪密码"]) {
            [self changeFalsePwdState];
        }
        else if ([supCell.titlelabel.text isEqualToString:@"输错密码抓拍"]) {
            [self changeZhuaPaiState];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MineLKSMXCTableViewCell *cell = (MineLKSMXCTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titlelabel.text isEqualToString:@"修改主密码"]) {
        ChangeLKSMXCPasswordViewController *pwd = [[ChangeLKSMXCPasswordViewController alloc]init];
        pwd.isMainPwd = YES;
        [self.navigationController pushViewController:pwd animated:YES];

    }
    else if ([cell.titlelabel.text isEqualToString:@"清除数据"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除本地所有数据，所有数据，所有数据，无法恢复！！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [SVProgressHUD showInfoWithStatus:@"完成"];
            }];
            [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_cleanAllData];
        }];
        [alert addAction:action];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:NULL];
    }
    else if ([cell.titlelabel.text isEqualToString:@"修改伪密码"]) {
        ChangeLKSMXCPasswordViewController *pwd = [[ChangeLKSMXCPasswordViewController alloc]init];
        pwd.isMainPwd = NO;
        [self.navigationController pushViewController:pwd animated:YES];
    }
    else if ([cell.titlelabel.text isEqualToString:@"修改密码"]) {
        ChangeLKSMXCPasswordViewController *pwd = [[ChangeLKSMXCPasswordViewController alloc]init];
        pwd.isMainPwd = NO;
        [self.navigationController pushViewController:pwd animated:YES];
    }
    else if ([cell.titlelabel.text isEqualToString:@"伪装图标"]) {
        if (@available(iOS 10.3, *)) {
            FixLKSMXCIconViewController *fix = [[FixLKSMXCIconViewController alloc]init];
            [self.navigationController pushViewController:fix animated:YES];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"当前系统版本不支持伪装图标"];
        }

    }
    else if ([cell.titlelabel.text isEqualToString:@"关于"]) {
        AboutLKSMXCViewController *about = [[AboutLKSMXCViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else if ([cell.titlelabel.text isEqualToString:@"隐私条款"]) {
        TKLKSMXCViewController *about = [[TKLKSMXCViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - action
- (void)changeZhuaPaiState{
    BOOL  zhuaPai = [LKSMXCUnit LUCK_getZhuaPaiEnable];
    if (!zhuaPai) {
        @autoreleasepool {
            if ([LKSMXCUnit LUCK_getCameraAuthorizationSatusIsAvailable]) {
                NSError *error;
                [AVCaptureDeviceInput deviceInputWithDevice:[self frontFacingCameraIfAvailable] error:&error];
            }
        }
    }
    [LKSMXCUnit LUCK_setZhuaPaiEnabel:!zhuaPai];
}
-(AVCaptureDevice *) frontFacingCameraIfAvailable {
    NSArray *videoDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevice) {
        if (device.position == AVCaptureDevicePositionFront) {
            captureDevice = device;
            break;
        }
    }
    return  captureDevice;
}
- (void)changeMainPwdState{
    BOOL  mainPwdState = [LKSMXCUnit LUCK_getMainPasswordEnable];
    NSString *mainPwd = [LKSMXCUnit LUCK_getMainPassword];
    if (!mainPwd.length) {
        [self initMainPwd];
        return;
    }
    NSString *title;
    NSString *message;
    title = mainPwdState?@"关闭主密码":@"开启主密码";
    message = @"请输入正确的主密码";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView reloadData];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:mainPwdState?@"关闭":@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields[0];
        if ([field.text isEqualToString:mainPwd]) {
            [LKSMXCUnit LUCK_setMainPasswordEnabel:!mainPwdState];
            [self.tableView reloadData];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"密码错误"];
            [self.tableView reloadData];
        }
    }];

    [alert addAction:action];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"输入主密码";
    }];
    UITextField *field = alert.textFields[0];
    RAC(confirm,enabled) = [field.rac_textSignal map:^id _Nullable(NSString * value) {
        return @(value.length > 0);
    }];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)initMainPwd{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置主密码" message:@"设置并开启主密码,主密码不能与伪密码一样" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView reloadData];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields[0];
        NSString *fpwd = [LKSMXCUnit LUCK_getFalsePassword];
        if ([fpwd isEqualToString:field.text]) {
            [SVProgressHUD showInfoWithStatus:@"主密码不能与伪密码一样！"];
            [self.tableView reloadData];
        }
        else{
            [LKSMXCUnit LUCK_setMainPasswordEnabel:YES];
            [LKSMXCUnit LUCK_setMainPassword:field.text];
            [self.tableView reloadData];
        }

    }];
    [alert addAction:action];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入主密码";
    }];
    UITextField *field = alert.textFields[0];
    RAC(confirm,enabled) = [field.rac_textSignal map:^id _Nullable(NSString * value) {
        return @(value.length > 0);
    }];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)changeFalsePwdState{
    BOOL  mainPwdState = [LKSMXCUnit LUCK_getFalsePasswordEnable];
    NSString *mainPwd = [LKSMXCUnit LUCK_getFalsePassword];
    if (!mainPwd.length) {
        [self initFalsePwd];
        return;
    }
    NSString *title;
    NSString *message;
    title = mainPwdState?@"关闭伪密码":@"开启伪密码";
    message = @"请输入正确的伪密码";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView reloadData];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:mainPwdState?@"关闭":@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields[0];
        if ([field.text isEqualToString:mainPwd]) {
            [LKSMXCUnit LUCK_setFalsePasswordEnabel:!mainPwdState];
            [self.tableView reloadData];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"密码错误"];
            [self.tableView reloadData];
        }
    }];
    
    [alert addAction:action];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"输入伪密码";
    }];
    UITextField *field = alert.textFields[0];
    RAC(confirm,enabled) = [field.rac_textSignal map:^id _Nullable(NSString * value) {
        return @(value.length > 0);
    }];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)initFalsePwd{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置伪密码" message:@"设置并开启伪密码,伪密码不能与主密码一样" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView reloadData];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields[0];
        
        NSString *mpwd = [LKSMXCUnit LUCK_getMainPassword];
        if ([mpwd isEqualToString:field.text]) {
            [SVProgressHUD showInfoWithStatus:@"伪密码不能与主密码一样！"];
            [self.tableView reloadData];
        }
        else{
            [LKSMXCUnit LUCK_setFalsePasswordEnabel:YES];
            [LKSMXCUnit LUCK_setFalsePassword:field.text];
            [self.tableView reloadData];
        }
        
    }];
    [alert addAction:action];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入伪密码";
    }];
    UITextField *field = alert.textFields[0];
    RAC(confirm,enabled) = [field.rac_textSignal map:^id _Nullable(NSString * value) {
        return @(value.length > 0);
    }];
    [self presentViewController:alert animated:YES completion:NULL];
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
