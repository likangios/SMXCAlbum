//
//  AlbumLKSMXCModel.h
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhotoLKSMXCModel;
@interface AlbumLKSMXCModel : NSObject

@property(nonatomic,strong) NSString *abid;

@property(nonatomic,strong) NSString *albumName;

@property(nonatomic,strong) NSNumber *albumCount;

@property(nonatomic,strong) NSString *isSecret;

@property(nonatomic,strong) NSArray <PhotoLKSMXCModel *>*photos;


@end
