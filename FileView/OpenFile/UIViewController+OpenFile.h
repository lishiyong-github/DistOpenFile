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
 * materialID : 文件的ID(唯一标识) 如：3.8656b3fb-95c5-4855-9b90-90f572fd5d32
 */
- (void)openFileWithName:(NSString *)name path:(NSString *)path materialID:(NSString *)materialID local:(BOOL)local;
@end
