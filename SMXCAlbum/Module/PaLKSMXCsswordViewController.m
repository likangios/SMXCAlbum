//
//  PaLKSMXCsswordViewController.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/22.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "PaLKSMXCsswordViewController.h"
#import "AppDelegate.h"
#import "LKSMXCTabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import "AlbumLKSMXCModel.h"
#import "LocalLKSMXCDataManager.h"
@interface PaLKSMXCsswordViewController ()<UITextFieldDelegate,AVCapturePhotoCaptureDelegate>

@property(nonatomic,strong) AVCaptureVideoPreviewLayer *previewlayer;

@property(nonatomic,strong) AVCaptureSession *captureSession;

@property(nonatomic,strong) AVCaptureDeviceInput *inputCapture;

@property(nonatomic,strong) AVCaptureConnection *captureConnection;

@property(nonatomic,strong) AVCaptureStillImageOutput *outputCapture;

@property(nonatomic,strong) UITextField *pwdTF;

@property(nonatomic,assign) BOOL hasSecretAlbum;

@end

@implementation PaLKSMXCsswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSError *error;
    if ([LKSMXCUnit LUCK_getZhuaPaiEnable]) {
    self.inputCapture = [AVCaptureDeviceInput deviceInputWithDevice:[self frontFacingCameraIfAvailable] error:&error];
    if (error == nil) {
        self.outputCapture = [[AVCaptureStillImageOutput alloc]init];
        [self.outputCapture setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
        
        self.captureSession = [[AVCaptureSession alloc]init];
        [self.captureSession addInput:self.inputCapture];
        [self.captureSession addOutput:self.outputCapture];
        [self.captureSession startRunning];
        
        self.previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.previewlayer.frame = self.view.frame;
        self.previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:self.previewlayer];
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = self.view.frame;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        [imageView bk_whenTapped:^{
            [self.pwdTF endEditing:YES];
        }];
        }
    }
    
    [self setNavBarTitle:@"请输入密码"];
    [self setRightItemTitle:@"完成"];
    [self.view addSubview:self.pwdTF];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.customNavBar.mas_bottom).offset(70);
        make.height.mas_equalTo(40);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.6);
    }];
    [self.pwdTF becomeFirstResponder];
    RAC(self.rightItemBtn,enabled) = [self.pwdTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 0);
    }];
    @weakify(self);
    [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if ([x isEqualToString:[LKSMXCUnit LUCK_getMainPassword]]) {
            [LKSMXCUnit LUCK_setUserType:type_admin];
            [self performSelector:@selector(LUCK_dismissAction) withObject:nil afterDelay:0.3];
        }
        else if ([x isEqualToString:[LKSMXCUnit LUCK_getFalsePassword]] && [LKSMXCUnit LUCK_getFalsePasswordEnable]){
            [LKSMXCUnit LUCK_setUserType:type_guest];
            [self performSelector:@selector(LUCK_dismissAction) withObject:nil afterDelay:0.3];

        }
    }];
    
}
- (void)rightItemAction:(id)sender{

    [self LUCK_checkPassword];

}
- (void)LUCK_dismissAction{
    [self.view endEditing:YES];
    if (!self.self.presentingViewController) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate LUCK_setUpRootVC];
    }
    else{
        [self dismissViewControllerAnimated:NO completion:NULL];
    }
}
- (UITextField *)pwdTF{
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc]init];
        _pwdTF.borderStyle = UITextBorderStyleRoundedRect;
        _pwdTF.delegate = self;
        _pwdTF.textAlignment = NSTextAlignmentCenter;
        _pwdTF.secureTextEntry = YES;
        _pwdTF.placeholder = @"输入密码";
        _pwdTF.returnKeyType = UIReturnKeyDone;
    }
    return _pwdTF;
}
- (BOOL)LUCK_checkPassword{
    if ([self.pwdTF.text isEqualToString:[LKSMXCUnit LUCK_getMainPassword]]) {
        [LKSMXCUnit LUCK_setUserType:type_admin];
        [self LUCK_dismissAction];
        return YES;
        
    }
    else if ([self.pwdTF.text isEqualToString:[LKSMXCUnit LUCK_getFalsePassword]] && [LKSMXCUnit LUCK_getFalsePasswordEnable]){
        [LKSMXCUnit LUCK_setUserType:type_guest];
        [self LUCK_dismissAction];
        return YES;
    }
    else{
        self.pwdTF.text = @"";
        [self.pwdTF becomeFirstResponder];
        [SVProgressHUD showInfoWithStatus:@"密码错误"];
        //抓拍
        if ([LKSMXCUnit LUCK_getZhuaPaiEnable]) {
            AlbumLKSMXCModel *secretAlbum = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_getSecretAlbumModel];
            if (secretAlbum == nil) {
                self.hasSecretAlbum = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_insertAlbumModel:[self creatSecretAlbumModel]];
            }
            else{
                self.hasSecretAlbum = YES;
            }
            [self takePhoto];
        }

        return NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!textField.text.length) {
        return NO;
    }
    return [self LUCK_checkPassword];
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
- (void)takePhoto{
    AVCaptureConnection * videoConnection = nil;
    for (AVCaptureConnection *connect in self.outputCapture.connections) {
        for (AVCaptureInputPort *port in connect.inputPorts) {
            if (port.mediaType == AVMediaTypeVideo) {
                videoConnection = connect;
                break;
            }
        }
    }
    if (videoConnection == nil) {
        return;
    }
    if (!self.hasSecretAlbum) {
        return;
    }
    [self.outputCapture captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image =[UIImage imageWithData:data];
        [self LUCK_addImageToDocument:image];
        NSLog(@"data.length:%ld",data.length);
    }];
}

- (void)LUCK_addImageToDocument:(UIImage *)image{
    NSString *imageName = [NSString stringWithFormat:NEDecodeOcString(kvlilwYzXzLmWZOA,sizeof(kvlilwYzXzLmWZOA)),[[NSDate date] timeIntervalSince1970],arc4random()%1000000];
    [[SDImageCache sharedImageCache] storeImage:image forKey:[[imageName SAblum_base64Encode] SAblum_md5] completion:^{
        AlbumLKSMXCModel *secModel = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_getSecretAlbumModel];
        
        PhotoLKSMXCModel *lastModel = nil;
        if (secModel.photos.count) {
           lastModel = secModel.photos.lastObject;
        }
        PhotoLKSMXCModel *model = [[PhotoLKSMXCModel alloc]init];
        model.imgName = [[imageName SAblum_base64Encode] SAblum_md5];
        model.parentId = secModel.abid;
        if (lastModel) {
            model.pid = [NSString stringWithFormat:NEDecodeOcString(qNnfPBHoyNFHGRoA,sizeof(qNnfPBHoyNFHGRoA)),lastModel.pid.integerValue + 1];
        }
        else{
            model.pid = NEDecodeOcString(faXpwnUKqAfWjVeY,sizeof(faXpwnUKqAfWjVeY));
        }
        BOOL result = [[LocalLKSMXCDataManager LUCK_shareInstance] LUCK_insertPhotoModel:model];
        if (result) {
            NSLog(@"入侵者 抓拍成功");
        }
    }];
}

- (AlbumLKSMXCModel *)creatSecretAlbumModel{
    AlbumLKSMXCModel *model = [[AlbumLKSMXCModel alloc]init];
    model.albumName = @"入侵者抓拍";
    model.albumCount = @0;
    model.photos = @[];
    model.isSecret = NEDecodeOcString(nyoRZBfWDXvtTxGE,sizeof(nyoRZBfWDXvtTxGE));
    model.abid = NEDecodeOcString(CLQJBokYeTiJoQXf,sizeof(CLQJBokYeTiJoQXf));
    return model;
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
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
