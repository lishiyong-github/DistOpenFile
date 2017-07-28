//
//  UIViewController+ShowFileDetail.h
//  nbOneMap
//
//  Created by shiyong_li on 17/4/20.
//  Copyright © 2017年 dist. All rights reserved.
//读取pdf文件等等

#import <UIKit/UIKit.h>

@interface UIViewController (OpenFile)
/*
 * name: 文件名 如：文件.pdf
 * path: 文件的下载路径
 * ext : 文件的后缀名 如：pdf
 */
- (void)openFileWithName:(NSString *)name path:(NSString *)path ext:(NSString *)ext local:(BOOL)local;
@end
