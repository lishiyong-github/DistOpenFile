//
//  FileTopView.m
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import "FileTopView.h"
#import "PureLayout.h"
@interface FileTopView ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *reloadButton;
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
        [self addSubview:self.reloadButton];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)myUpdateViewConstraints
{
    [@[self.nameLabel,self.closeButton,self.reloadButton] autoAlignViewsToAxis:ALAxisHorizontal];
    [self.nameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.bottomLine autoSetDimension:ALDimensionHeight toSize:1];
    
    [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.reloadButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.closeButton withOffset:-10];
    [self.reloadButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:20];
    [@[self.closeButton,self.reloadButton] autoSetViewsDimension:ALDimensionWidth toSize:40];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.nameLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
        [self.nameLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
    }];
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

- (void)reload
{
    if (self.reloadHandler) {
        self.reloadHandler();
    }
}
#pragma mark - getter
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel newAutoLayoutView];
        [_nameLabel setTintColor:[UIColor blackColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _nameLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton newAutoLayoutView];
        [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton newAutoLayoutView];
        [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [_reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIView newAutoLayoutView];
        [_bottomLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _bottomLine;
}
@end
