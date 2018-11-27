//
//  MineLKSMXCTableViewCell.h
//  SecretAlbum
//
//  Created by perfay on 2018/10/25.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineLKSMXCTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *IconImageV;

@property(nonatomic,strong) UILabel *titlelabel;

@property(nonatomic,assign) BOOL showAccessory;

@property(nonatomic,strong) UISwitch *enableSwitchVC;

@end
