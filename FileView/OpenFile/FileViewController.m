//
//  FileViewController.m
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import "FileViewController.h"
#import "FileProgressView.h"
#import "FilePhotoView.h"
#import "AFNetworking.h"
#import "PureLayout.h"
@interface FileViewController ()
/******************* view *******************/
@property (nonatomic,strong) FileProgressView *progressView;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) FilePhotoView *photoView;
@property (nonatomic,strong) UILabel *dwgLabel;

@property (nonatomic,strong) NSString *localPath;
@property (nonatomic,strong) NSURLSessionDownloadTask  *downloadTask;
@property (nonatomic,strong) UIDocumentInteractionController *documentController;
//navigation bar
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *reloadButton;
@end

@implementation FileViewController
- (instancetype)initWithFileName:(NSString *)fileName filePath:(NSString *)filePath materialID:(NSString *)materialID local:(BOOL)local
{
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.filePath = filePath;
        self.materialID = materialID;
        self.local = local;
        if (local) {
            _localPath = filePath;
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    // configSubView
    [self configNavigationBar];
    [self configSubView];
    //download file
    if (self.local || [[NSFileManager defaultManager] fileExistsAtPath:self.localPath]) {
        [self openFile];
    }else{
        [self downloadFile];
    }
}

- (void)configNavigationBar
{
    self.title = self.fileName;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:self.reloadButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:self.closeButton];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)configSubView
{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.dwgLabel];
    
    //addConstraints
    [self addConstraints];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)addConstraints
{
    [self.progressView autoCenterInSuperview];
    [self.progressView autoSetDimensionsToSize:CGSizeMake(150, 150)];
    
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.photoView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.dwgLabel autoCenterInSuperview];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.downloadTask cancel];
}

#pragma mark - getter

- (FileProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[FileProgressView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        _progressView.center = self.view.center;
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _progressView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [UIWebView newAutoLayoutView];
        [_webView setHidden:YES];
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

- (FilePhotoView *)photoView
{
    if (!_photoView) {
        _photoView = [FilePhotoView newAutoLayoutView];
        [_photoView setHidden:YES];
    }
    return _photoView;
}

- (UILabel *)dwgLabel
{
    if (!_dwgLabel) {
        _dwgLabel = [UILabel newAutoLayoutView];
        [_dwgLabel setText:@"若要打开文件，请单击右上角“刷新”按钮。"];
        [_dwgLabel setFont:[UIFont systemFontOfSize:14]];
        [_dwgLabel setHidden:YES];
    }
    return _dwgLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
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
        _reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [_reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(openFile) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (NSString *)localPath
{
    if (!_localPath) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileLocalPath = [documentPath stringByAppendingPathComponent:@"material"];
        BOOL dictionary;
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileLocalPath isDirectory:&dictionary]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:fileLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _localPath = [NSString stringWithFormat:@"%@/%@.%@",fileLocalPath,self.materialID,self.fileName.pathExtension];
    }
    return _localPath;
}

#pragma mark - download file
- (void)downloadFile
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.filePath]];
    __weak __typeof__(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *progress){
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        CGFloat haveFinished = [[NSString stringWithFormat:@"%.2f",[progress fractionCompleted]] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.progressView setHaveFinished:haveFinished];
        });
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        return [NSURL fileURLWithPath:self.localPath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"%@",[error description]);
        }else{
            [strongSelf downloadFinish];
            
        }
        
    }];
    [downloadTask resume];
    self.downloadTask = downloadTask;
}

- (void)downloadFinish
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openFile];
    });
}

- (void)openFile
{
    [self.progressView removeFromSuperview];
    NSString *fileExt = [self.fileName pathExtension];
    if ([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"] ||[fileExt isEqualToString:@"bmp"]) {
        [self.photoView setHidden:NO];
        self.photoView.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40);
        [self.photoView showImageFilePath:self.localPath];
    }else if ([fileExt isEqualToString:@"dwg"] || [fileExt isEqualToString:@"zip"]|| [fileExt isEqualToString:@"rar"]){
        [self.dwgLabel setHidden:NO];
        UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.localPath]];
        self.documentController = documentController;
        [self.documentController presentOptionsMenuFromRect:CGRectMake(455, 440, 100, 100) inView:self.view animated:YES];
    }else if ([fileExt isEqualToString:@"txt"]){
        self.webView.hidden = NO;
        NSData *txtData = [NSData dataWithContentsOfFile:self.localPath];
        //自定义一个编码方式
        [self.webView loadData:txtData MIMEType:@"text/txt" textEncodingName:@"GBK" baseURL:[NSURL fileURLWithPath:self.localPath]];
    }else{
        self.webView.hidden = NO;
        NSURL * url = [NSURL fileURLWithPath:self.localPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest: request];
    }
}

@end
