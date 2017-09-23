//
//  UIViewController+ShowFileDetail.m
//  nbOneMap
//
//  Created by shiyong_li on 17/4/20.
//  Copyright © 2017年 dist. All rights reserved.
//

#import "UIViewController+OpenFile.h"
#import "FileViewController.h"
@implementation UIViewController (OpenFile)
-(void)openFileWithName:(NSString *)name path:(NSString *)path materialID:(NSString *)materialID local:(BOOL)local
{
    FileViewController   *fileViewController = [[FileViewController alloc] initWithFileName:name filePath:path materialID:materialID local:local];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fileViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
