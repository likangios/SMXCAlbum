//
//  PhotosLKSMXCCollectionViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "PhotosLKSMXCCollectionViewController.h"
#import "PhotoLKSMXCCollectionViewCell.h"
#import "PhotoLKSMXCModel.h"
#import "LocalLKSMXCDataManager.h"
#import <YBImageBrowser.h>
#import "PaLKSMXCsswordViewController.h"
#import "TZImagePickerController.h"
@interface PhotosLKSMXCCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) UIToolbar *toolBarView;

@property(nonatomic,strong) NSMutableArray *selectDataArray;

@property(nonatomic,assign) NSInteger selectedCount;

@property(nonatomic,assign) BOOL isCanSelect;

@property(nonatomic,strong) UIButton *addButton;

@end

@implementation PhotosLKSMXCCollectionViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.selectDataArray = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    }
    return _addButton;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (ScreenW - 3)/4.0;
        layout.itemSize = CGSizeMake(width,width);
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotoLKSMXCCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoLKSMXCCollectionViewCell"];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDefaultBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBarTitle:self.albumName];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.customNavBar.mas_bottom);
    }];
    [self setRightItemTitle:@"选择"];
    [self.rightItemBtn setTitle:@"取消" forState:UIControlStateSelected];
    [self LUCK_addToolBar];
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-80);
        make.right.mas_equalTo(-30);
        make.size.mas_equalTo(64);
    }];
    @weakify(self);
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self LUCK_showAddImageSheetView];
    }];
    [[RACObserve(self, selectedCount) distinctUntilChanged]  subscribeNext:^(NSNumber * value) {
        @strongify(self);
        if (value.integerValue == 0) {
            self.titleLabel.text =  @"选择项目";
        }
        else{
            self.titleLabel.text =  [NSString stringWithFormat:@"已选择%ld张照片",value.integerValue];
        }
    }];
    RAC(self.addButton,hidden) = RACObserve(self.rightItemBtn, selected);
    RAC(self.leftItemBtn,hidden) = RACObserve(self.rightItemBtn, selected);
    RAC(self,isCanSelect) = RACObserve(self.rightItemBtn, selected);
    RAC(self.titleLabel,text) = [RACObserve(self.rightItemBtn, selected) map:^id _Nullable(NSNumber * value) {
        @strongify(self);
        if (value.boolValue) {
            return @"选择项目";
        }
        else{
            return self.albumName;
        }
    }];
    [RACObserve(self.rightItemBtn, selected) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [UIView animateWithDuration:0.1 animations:^{
            if (x.boolValue) {
                self.toolBarView.transform = CGAffineTransformIdentity;
            }
            else{
                self.toolBarView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 45);
            }
        }];
    }];
}
- (void)LUCK_addToolBar{
    self.toolBarView = [[UIToolbar alloc]init];
    [self.view addSubview:self.toolBarView];
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAction handler:^(id sender) {
        [self shareAction];
    }];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemTrash handler:^(id sender) {
        [self deleteAction];
    }];
    UIBarButtonItem *move = [[UIBarButtonItem alloc] bk_initWithTitle:@"移动到" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self moveAction];
    }];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.toolBarView.items = @[shareItem,space,move,space,delete];
    self.toolBarView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 45);
    
    RAC(shareItem,enabled) = RACObserve(self, selectedCount);
    RAC(delete,enabled) = RACObserve(self, selectedCount);
    RAC(move,enabled) = RACObserve(self, selectedCount);
    
}
#pragma mark  - Action

- (void)rightItemAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.selectDataArray removeAllObjects];
        self.selectedCount = 0;
        [self.collectionView reloadData];
    }
    
}
- (void)LUCK_showAddImageSheetView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LUCK_selectPhotoWithType:1];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"从相机添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LUCK_selectPhotoWithType:2];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:album];
    [alert addAction:camera];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)LUCK_selectPhotoWithType:(NSInteger)type{
    
    if (type == 1) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    else{
        if (![LKSMXCUnit LUCK_getCameraAuthorizationSatusIsAvailable]) {
            return;
        }
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.mediaTypes = @[@"public.image"];
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - 分享
- (void)shareAction{
    NSMutableArray *imgs = [NSMutableArray array];
    for (PhotoLKSMXCModel *model in self.selectDataArray) {
        UIImage *image = [LKSMXCUnit LUCK_getCacheImageWithKey:model.imgName];
        if (image) {
            [imgs addObject:image];
        }
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:imgs applicationActivities:@[]];
    activityVC.modalInPopover = YES;
    [self presentViewController:activityVC animated:YES completion:NULL];
}
#pragma mark - 删除
- (void)deleteAction{
    for (PhotoLKSMXCModel *model in self.selectDataArray) {
        [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_deletePhotoModelWithPid:model.pid];
    }
    [self.dataArray removeObjectsInArray:self.selectDataArray];
    [self.selectDataArray removeAllObjects];
    self.selectedCount = 0;
    [self.collectionView reloadData];
}
#pragma mark - 移动
- (void)moveAction{
    NSArray *albums = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_getAllAlbumModel];
    if (albums.count < 2) {
        [SVProgressHUD showInfoWithStatus:@"没有其他可用相册"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"移动照片到" preferredStyle:UIAlertControllerStyleActionSheet];
    for (AlbumLKSMXCModel *model in albums) {
        if (![model.albumName isEqualToString:self.albumName]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:model.albumName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self moveToAlbumWithName:action.title];;
            }];
            [alert addAction:action];
        }
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:NULL];
}
- (void)moveToAlbumWithName:(NSString *)title{
    NSArray *albums = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_getAllAlbumModel];
    AlbumLKSMXCModel *model = [albums bk_match:^BOOL(AlbumLKSMXCModel *obj) {
        return [obj.albumName isEqualToString:title];
    }];
    if (model) {
        [self.selectDataArray enumerateObjectsUsingBlock:^(PhotoLKSMXCModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.parentId = model.abid;
            [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_updatePhotoModel:obj];
        }];
        [self.dataArray removeObjectsInArray:self.selectDataArray];
        [self.selectDataArray removeAllObjects];
        self.selectedCount = 0;
    }
    [self.collectionView reloadData];
}
#pragma mark - UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoLKSMXCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoLKSMXCCollectionViewCell" forIndexPath:indexPath];
    PhotoLKSMXCModel *model = self.dataArray[indexPath.row];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:model.imgName];
    if (cacheImage == nil) {
        cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.imgName];
    }
    cell.imageView.image = cacheImage;
    cell.selectedVw.hidden = ![self.selectDataArray containsObject:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCanSelect) {
        PhotoLKSMXCModel *model = self.dataArray[indexPath.row];
        if ([self.selectDataArray containsObject:model]) {
            [self.selectDataArray removeObject:model];
        }
        else{
            [self.selectDataArray addObject:model];
        }
        self.selectedCount = self.selectDataArray.count;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    else{
        //预览
  
            NSMutableArray *array = [NSMutableArray array];
            for (PhotoLKSMXCModel *model in self.dataArray) {
                YBImageBrowseCellData *data = [YBImageBrowseCellData new];
                data.sourceObject = [LKSMXCUnit LUCK_getCacheImageWithKey:model.imgName];
                [array addObject:data];
            }
        YBImageBrowser *imageBrowser = [YBImageBrowser new];
        imageBrowser.dataSourceArray = array;
        imageBrowser.currentIndex = indexPath.row;
        [imageBrowser show];
    }
}
#pragma mark - ZTImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [photos enumerateObjectsUsingBlock:^(UIImage * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addImageToDocument:obj];
    }];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功导入" message:@"您所选的照片已经成功导入，是否删除相册里面的照片？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAc = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:assets];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:deleteAc];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:NULL];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self addImageToDocument:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)addImageToDocument:(UIImage *)image{
    NSString *imageName = [NSString stringWithFormat:@"%f_%d",[[NSDate date] timeIntervalSince1970],arc4random()%1000000];
    [[SDImageCache sharedImageCache] storeImage:image forKey:[[imageName SAblum_base64Encode] SAblum_md5] completion:^{
        PhotoLKSMXCModel *lastModel = self.dataArray.lastObject;
        PhotoLKSMXCModel *model = [[PhotoLKSMXCModel alloc]init];
        model.imgName = [[imageName SAblum_base64Encode] SAblum_md5];
        model.parentId = self.albumId;
        if (lastModel) {
            model.pid = [NSString stringWithFormat:@"%ld",lastModel.pid.integerValue + 1];
        }
        else{
            model.pid = @"1000";
        }
        [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_insertPhotoModel:model];
        [self.dataArray addObject:model];
        NSLog(@"====%@",self.dataArray);
        [self.collectionView reloadData];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark -
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
