//
//  AlbumLKSMXCViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/22.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "AlbumLKSMXCViewController.h"
#import "LocalLKSMXCDataManager.h"
#import "PhotosLKSMXCCollectionViewController.h"
#import "AlbumLKSMXCTableViewCell.h"
@interface AlbumLKSMXCViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray <AlbumLKSMXCModel *>*albumArray;

@property(nonatomic,strong) UITextField *albumNameTF;


@end

@implementation AlbumLKSMXCViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[AlbumLKSMXCTableViewCell class] forCellReuseIdentifier:@"AlbumLKSMXCTableViewCell"];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self LUCK_reloadAlbumData];
}
- (void)LUCK_reloadAlbumData{
    self.albumArray = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_getAllAlbumModel];
    if (self.albumArray.count) {
        AlbumLKSMXCModel *model = self.albumArray.lastObject;
        if ([model.abid isEqualToString:@"999"]) {
            [self.albumArray insertObject:model atIndex:0];
            [self.albumArray removeLastObject];
        }
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarTitle:@"照片"];
    [self setRightItemTitle:@"添加"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.customNavBar.mas_bottom);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self LUCK_reloadAlbumData];
    }];
}
- (void)rightItemAction:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建相册" message:@"输入相册名称" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.albumNameTF endEditing:YES];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LUCK_addAlbum];
        [self.albumNameTF endEditing:YES];
    }];
    [alert addAction:action];
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.albumNameTF = textField;
    }];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)LUCK_addAlbum{
    AlbumLKSMXCModel *lastModel;
    if (self.albumArray.count) {
        NSMutableArray  *sortArray = [self.albumArray mutableCopy];
        [sortArray sortUsingComparator:^NSComparisonResult(AlbumLKSMXCModel* obj1, AlbumLKSMXCModel * obj2) {
            return obj1.abid > obj2.abid;
        }];
        lastModel = sortArray.lastObject;
    }
    
    AlbumLKSMXCModel *model = [[AlbumLKSMXCModel alloc]init];
    model.albumName = self.albumNameTF.text;
    model.albumCount = @0;
    model.photos = @[];
    if ([LKSMXCUnit LUCK_getUserType] == type_guest) {
        model.isSecret = @"0";
        model.abid = [NSString stringWithFormat:@"%ld",lastModel?(lastModel.abid.integerValue + 1):10000];

    }
    else{
        model.isSecret = @"1";
        model.abid = [NSString stringWithFormat:@"%ld",lastModel?(lastModel.abid.integerValue + 1):1000];

    }
   BOOL result = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_insertAlbumModel:model];
    if (result) {
        [self LUCK_reloadAlbumData];
    }
    else{
        [SVProgressHUD showInfoWithStatus:@"添加失败"];
    }
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumLKSMXCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumLKSMXCTableViewCell"];
    AlbumLKSMXCModel *model = self.albumArray[indexPath.row];
    cell.albumNameLabel.text = model.albumName;
    cell.albumCountLabel.text = [NSString stringWithFormat:@"%ld张",model.albumCount.integerValue];
    
    PhotoLKSMXCModel *lastModel = model.photos.lastObject;
    cell.newestImageView.image = [LKSMXCUnit LUCK_getCacheImageWithKey:lastModel.imgName];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumLKSMXCModel *model = self.albumArray[indexPath.row];
    PhotosLKSMXCCollectionViewController *vc = [[PhotosLKSMXCCollectionViewController alloc]init];
    vc.albumName = model.albumName;
    vc.albumId = model.abid;
    vc.dataArray = model.photos;
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除相册及照片";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AlbumLKSMXCModel *model = self.albumArray[indexPath.row];
        [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_deleteAlbumModelWithAbid:model.abid];
        [self LUCK_reloadAlbumData];
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
