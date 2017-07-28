//
//  FileTopView.m
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import "FileTopView.h"

@interface FileTopView ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIView *bottomLine;

@end
@implementation FileTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.bottomLine];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.nameLabel setFrame:CGRectMake(15, 5, self.frame.size.width-115, 30)];
    [self.closeButton setFrame:CGRectMake(self.frame.size.width-80, 5, 60, 30)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
}

- (void)setTitle:(NSString *)title
{
    [self.nameLabel setText:title];
}

- (void)close
{
    if (self.closeHandler) {
        self.closeHandler();
    }
}
#pragma mark - getter
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_nameLabel setTintColor:[UIColor blackColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
//        [_nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    return _nameLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
//        [_nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        [_bottomLine setBackgroundColor:[UIColor lightGrayColor]];
//        [_bottomLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return _bottomLine;
}
@end
