//
//  LocalLKSMXCDataManager.h
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumLKSMXCModel.h"
#import "PhotoLKSMXCModel.h"

@interface LocalLKSMXCDataManager : NSObject
+ (instancetype)LUCK_shareInstance;
- (NSArray <AlbumLKSMXCModel *>*)LUCK_getAllAlbumModel;
- (BOOL)LUCK_insertAlbumModel:(AlbumLKSMXCModel *)model;
- (BOOL)LUCK_deleteAlbumModelWithAbid:(NSString *)abid;


- (AlbumLKSMXCModel *)LUCK_getSecretAlbumModel;
- (NSArray <PhotoLKSMXCModel *>*)getAllPhotosModelWithParentId:(NSString *)parentId;
- (BOOL)LUCK_insertPhotoModel:(PhotoLKSMXCModel *)model;
- (BOOL)LUCK_deletePhotoModelWithPid:(NSString *)pid;
- (BOOL)LUCK_updatePhotoModel:(PhotoLKSMXCModel *)model;

- (void)LUCK_cleanAllData;
@end
