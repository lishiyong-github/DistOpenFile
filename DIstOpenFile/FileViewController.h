//
//  FileViewController.h
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
// 文件查看

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController
/**
 * fileName: 文件名字
 * filePath：文件地址
 * fileExt：文件后缀
 * local  : 是否是本地文件
 */
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *fileExt;
@property (nonatomic,assign) BOOL local;
- (instancetype)initWithFileName:(NSString *)fileName filePath:(NSString *)filePath fileExt:(NSString *)fileExt local:(BOOL)local;
@end
