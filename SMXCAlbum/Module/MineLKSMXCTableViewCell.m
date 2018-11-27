//
//  MineLKSMXCTableViewCell.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/25.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "MineLKSMXCTableViewCell.h"

@implementation MineLKSMXCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.IconImageV];
        [self.contentView addSubview:self.titlelabel];
        [self.contentView addSubview:self.enableSwitchVC];
        
        [self.IconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(self.IconImageV.mas_height);
        }];
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.IconImageV.mas_centerY);
            make.left.equalTo(self.IconImageV.mas_right).offset(15);
        }];
        [self.enableSwitchVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.IconImageV.mas_centerY);
            make.right.mas_equalTo(-30);
        }];
    }
    return self;
}
- (UIImageView *)IconImageV{
    if(!_IconImageV) {
        _IconImageV = [UIImageView new];
        _IconImageV.contentMode = UIViewContentModeScaleAspectFill;
        _IconImageV.backgroundColor = [UIColor clearColor];
    }
    return _IconImageV;
}
- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel new];
        _titlelabel.font = [UIFont systemFontOfSize:16];
        _titlelabel.textColor = [UIColor colorWithHexString:@"000000"];
        _titlelabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titlelabel;
}
- (UISwitch *)enableSwitchVC{
    if (!_enableSwitchVC) {
        _enableSwitchVC = [[UISwitch alloc]init];
    }
    return _enableSwitchVC;
}
- (void)setShowAccessory:(BOOL)showAccessory{
    if (showAccessory) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
