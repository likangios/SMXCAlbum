//
//  AlbumLKSMXCTableViewCell.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "AlbumLKSMXCTableViewCell.h"

@implementation AlbumLKSMXCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.newestImageView];
        [self.contentView addSubview:self.albumNameLabel];
        [self.contentView addSubview:self.albumCountLabel];
        [self.newestImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.top.mas_equalTo(5);
            make.width.mas_equalTo(self.newestImageView.mas_height);
        }];
        
        [self.albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.newestImageView.mas_right).offset(15);
            make.right.equalTo(self.albumCountLabel.mas_left).offset(-10);
        }];
        [self.albumCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-15);
        }];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)newestImageView{
    if(!_newestImageView) {
        _newestImageView = [UIImageView new];
        _newestImageView.contentMode = UIViewContentModeScaleAspectFill;
        _newestImageView.backgroundColor = [UIColor clearColor];
        _newestImageView.clipsToBounds = YES;
    }
    return _newestImageView;
}
- (UILabel *)albumNameLabel{
    if (!_albumNameLabel) {
        _albumNameLabel = [UILabel new];
        _albumNameLabel.font = [UIFont systemFontOfSize:14];
        _albumNameLabel.textColor = [UIColor colorWithHexString:NEDecodeOcString(IJHSIlHVCPWKyaOB,sizeof(IJHSIlHVCPWKyaOB))];
        _albumNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _albumNameLabel;
}
- (UILabel *)albumCountLabel{
    if (!_albumCountLabel) {
        _albumCountLabel = [UILabel new];
        _albumCountLabel.font = [UIFont systemFontOfSize:14];
        _albumCountLabel.textColor = [UIColor colorWithHexString:NEDecodeOcString(IJHSIlHVCPWKyaOB,sizeof(IJHSIlHVCPWKyaOB))];
        _albumCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _albumCountLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
