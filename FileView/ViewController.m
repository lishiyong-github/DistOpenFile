//
//  ViewController.m
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+OpenFile.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = self.view.center;
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clicked
{
    [self openFileWithName:@"公司服务器.txt" path:@"http://58.246.138.178:8040/jxyd/ServiceProvider.ashx?type=smartplan&action=downloadMaterial&fileId=914010" materialID:@"1" local:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
