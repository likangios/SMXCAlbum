//
//  PhotosLKSMXCCollectionViewController.h
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "LKSMXCBaseSetViewController.h"

@interface PhotosLKSMXCCollectionViewController : LKSMXCBaseSetViewController

@property(nonatomic,strong) NSString *albumId;

@property(nonatomic,strong) NSString *albumName;

@property(nonatomic,strong) NSMutableArray *dataArray;


@end
