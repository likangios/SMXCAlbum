//
//  PhotoLKSMXCCollectionViewCell.m
//  SecretAlbum
//
//  Created by perfay on 2018/10/23.
//  Copyright © 2018年 perfay. All rights reserved.
//

#import "PhotoLKSMXCCollectionViewCell.h"


@implementation PhotoLKSMXCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedVw];

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.selectedVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"cell_selected"];
        [self.selectedVw addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_offset(-3);
            make.size.mas_equalTo(24);
        }];

        
    }
    return self;
}
//
-(UIView *)selectedVw{
    if (!_selectedVw) {
        _selectedVw = [UIView new];
        _selectedVw.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        _selectedVw.hidden = YES;
    }
    return _selectedVw;
}
- (UIImageView *)imageView{
    if(!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor randomColor];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
@end
