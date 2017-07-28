//
//  FileTopView.h
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTopView : UIView
@property (nonatomic,copy) void(^closeHandler)();
- (void)setTitle:(NSString *)title;
@end
