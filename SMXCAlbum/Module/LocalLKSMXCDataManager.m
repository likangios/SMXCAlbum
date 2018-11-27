//
//  LocalLKSMXCDataManager.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "LocalLKSMXCDataManager.h"

@interface LocalLKSMXCDataManager ()

@property(nonatomic,strong) JQFMDB *jqdb;

@end

#define AlbumTable NEDecodeOcString(QEjNlGKlpcikKvyF,sizeof(QEjNlGKlpcikKvyF))

#define PhotoTable NEDecodeOcString(vHWlRIXmxCJdCgtW,sizeof(vHWlRIXmxCJdCgtW))

static LocalLKSMXCDataManager *_manager;
@implementation LocalLKSMXCDataManager
+ (instancetype)LUCK_shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LocalLKSMXCDataManager alloc]init];
    });
    return _manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.jqdb = [JQFMDB shareDatabase];
        [self.jqdb open];
        if (![self.jqdb jq_isExistTable:AlbumTable]) {
            [self.jqdb jq_createTable:AlbumTable dicOrModel:[AlbumLKSMXCModel class] excludeName:@[NEDecodeOcString(UWIvoClbhBaKgdXL,sizeof(UWIvoClbhBaKgdXL)),NEDecodeOcString(KAEspztNeAaFhOVV,sizeof(KAEspztNeAaFhOVV))]];
        }
        if (![self.jqdb jq_isExistTable:PhotoTable]) {
            [self.jqdb jq_createTable:PhotoTable dicOrModel:[PhotoLKSMXCModel class]];
        }
        
    }
    return self;
}
- (NSArray <AlbumLKSMXCModel *>*)LUCK_getAllAlbumModel{
    __block NSArray *resultArray = [NSArray array];
    NSString *splString;
    if ([LKSMXCUnit LUCK_getUserType] == type_guest) {
        splString = [NSString stringWithFormat:NEDecodeOcString(sEEDItgquAVxtdmB,sizeof(sEEDItgquAVxtdmB))];
    }
    else{
        splString = [NSString stringWithFormat:NEDecodeOcString(kctApQNiZfomHXUq,sizeof(kctApQNiZfomHXUq))];
    }
    [self.jqdb jq_inDatabase:^{
        resultArray = [self.jqdb jq_lookupTable:AlbumTable dicOrModel:[AlbumLKSMXCModel class] whereFormat:splString];
    }];
    [resultArray enumerateObjectsUsingBlock:^(AlbumLKSMXCModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self getAllPhotosModelWithParentId:obj.abid];
        obj.photos = array;
        obj.albumCount = @(array.count);
    }];
    return resultArray;
}
- (AlbumLKSMXCModel *)LUCK_getSecretAlbumModel{
    __block NSArray *resultArray = [NSArray array];
    NSString *splString = [NSString stringWithFormat:NEDecodeOcString(CxuPzPfQMWTdfkeJ,sizeof(CxuPzPfQMWTdfkeJ))];
    [self.jqdb jq_inDatabase:^{
        resultArray = [self.jqdb jq_lookupTable:AlbumTable dicOrModel:[AlbumLKSMXCModel class] whereFormat:splString];
    }];
    [resultArray enumerateObjectsUsingBlock:^(AlbumLKSMXCModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self getAllPhotosModelWithParentId:obj.abid];
        obj.photos = array;
        obj.albumCount = @(array.count);
    }];
    if (resultArray.count) {
        return resultArray.firstObject;
    }
    return nil;
}


- (BOOL)LUCK_insertAlbumModel:(AlbumLKSMXCModel *)model{
    __block BOOL success = NO;
    [self.jqdb jq_inDatabase:^{
        success = [self.jqdb jq_insertTable:AlbumTable dicOrModel:model];
    }];
    return success;
}
- (BOOL)LUCK_deleteAlbumModelWithAbid:(NSString *)abid{
    __block BOOL success = NO;
        NSString *splString = [NSString stringWithFormat:NEDecodeOcString(PBdcxavpAuNOlwXg,sizeof(PBdcxavpAuNOlwXg)),abid];
    [self.jqdb jq_inDatabase:^{
        success = [self.jqdb jq_deleteTable:AlbumTable whereFormat:splString];
    }];
    //删除相册里的照片
    [self deletePhotoModelWithParentId:abid];
    return success;
}
#pragma mark - photos

- (NSArray <PhotoLKSMXCModel *>*)getAllPhotosModelWithParentId:(NSString *)parentId{
    __block NSArray *resultArray = [NSArray array];
    NSString *splString = [NSString stringWithFormat:NEDecodeOcString(iaivIcnwczbMRwVc,sizeof(iaivIcnwczbMRwVc)),parentId];
    [self.jqdb jq_inDatabase:^{
        resultArray = [self.jqdb jq_lookupTable:PhotoTable dicOrModel:[PhotoLKSMXCModel class] whereFormat:splString];
    }];
    return resultArray;
}
- (BOOL)LUCK_updatePhotoModel:(PhotoLKSMXCModel *)model{
    __block BOOL success = NO;
    NSString *splString = [NSString stringWithFormat:NEDecodeOcString(lzbUlCkvmNmLDpfX,sizeof(lzbUlCkvmNmLDpfX)),model.pid];
    [self.jqdb jq_inDatabase:^{
        success = [self.jqdb jq_updateTable:PhotoTable dicOrModel:model whereFormat:splString];
    }];
    return success;
}
- (BOOL)LUCK_insertPhotoModel:(PhotoLKSMXCModel *)model{
    __block BOOL success = NO;
    [self.jqdb jq_inDatabase:^{
        success = [self.jqdb jq_insertTable:PhotoTable dicOrModel:model];
    }];
    return success;
}
//根据相册删除照片
- (BOOL)deletePhotoModelWithParentId:(NSString *)parentId{
    __block BOOL success = NO;
    NSString *splString = [NSString stringWithFormat:NEDecodeOcString(iaivIcnwczbMRwVc,sizeof(iaivIcnwczbMRwVc)),parentId];
    [self.jqdb jq_inDatabase:^{
        success = [self.jqdb jq_deleteTable:PhotoTable whereFormat:splString];
    }];
    return success;
}

- (BOOL)LUCK_deletePhotoModelWithPid:(NSString *)pid{
    __block BOOL success = NO;
    NSString *splString = [NSString stringWithFormat:NEDecodeOcString(lzbUlCkvmNmLDpfX,sizeof(lzbUlCkvmNmLDpfX)),pid];
    [self.jqdb jq_inDatabase:^{
        success = [self.jqdb jq_deleteTable:PhotoTable whereFormat:splString];
    }];
    return success;
}

- (void)LUCK_cleanAllData{
    if ([self.jqdb jq_deleteTable:AlbumTable]) {
        [self.jqdb jq_createTable:AlbumTable dicOrModel:[AlbumLKSMXCModel class] excludeName:@[NEDecodeOcString(UWIvoClbhBaKgdXL,sizeof(UWIvoClbhBaKgdXL)),NEDecodeOcString(KAEspztNeAaFhOVV,sizeof(KAEspztNeAaFhOVV))]];
    }
    if ([self.jqdb jq_deleteTable:PhotoTable]) {
        [self.jqdb jq_createTable:PhotoTable dicOrModel:[PhotoLKSMXCModel class]];
    }
}
@end
