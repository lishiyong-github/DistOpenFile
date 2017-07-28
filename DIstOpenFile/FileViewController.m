//
//  FileViewController.m
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import "FileViewController.h"
#import "FileTopView.h"
#import "FileProgressView.h"
#import "FilePhotoView.h"
#import "AFNetworking.h"
#import "PureLayout.h"
@interface FileViewController ()
/******************* view *******************/
@property (nonatomic,strong) FileTopView *topView;
@property (nonatomic,strong) FileProgressView *progressView;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) FilePhotoView *photoView;
@property (nonatomic,strong) UILabel *dwgLabel;

@property (nonatomic,strong) NSString *localPath;
@property (nonatomic,strong) NSURLSessionDownloadTask  *downloadTask;
@end

@implementation FileViewController
- (instancetype)initWithFileName:(NSString *)fileName filePath:(NSString *)filePath fileExt:(NSString *)fileExt local:(BOOL)local
{
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.filePath = filePath;
        self.fileExt = fileExt;
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
    [self configSubView];
    //download file
    if (self.local || [[NSFileManager defaultManager] fileExistsAtPath:self.localPath]) {
        [self openFile];
    }else{
        [self downloadFile];
    }
}

- (void)configSubView
{
    //add topview
    [self.view addSubview:self.topView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.dwgLabel];
    
    
    //addConstraints
    [self addConstraints];
    [self.topView setTitle:self.fileName];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)addConstraints
{
    [self.progressView autoCenterInSuperview];
    [self.progressView autoSetDimensionsToSize:CGSizeMake(150, 150)];
    
    [self.topView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.topView autoSetDimension:ALDimensionHeight toSize:40];
    
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.webView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topView];
    
    [self.photoView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.photoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topView];
    
    [self.dwgLabel autoCenterInSuperview];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.downloadTask cancel];
}

#pragma mark - getter
- (FileTopView *)topView
{
    if (!_topView) {
        _topView = [FileTopView newAutoLayoutView];
        __weak __typeof__(self) weakSelf = self;
        [_topView setCloseHandler:^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf close];
        }];
        [_topView setReloadHandler:^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf openFile];
        }];
    }
    return _topView;
}

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
    }
    return _dwgLabel;
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
        _localPath = [fileLocalPath stringByAppendingPathComponent:self.fileName];;
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
    if (![fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"] ||[fileExt isEqualToString:@"bmp"]) {
        [self.photoView setHidden:NO];
        self.photoView.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40);
        [self.photoView showImageFilePath:self.localPath];
    }else if ([fileExt isEqualToString:@"dwg"] || [fileExt isEqualToString:@"zip"]|| [fileExt isEqualToString:@"rar"]){
        [self.dwgLabel setHidden:NO];
        UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.localPath]];
        [documentController presentOptionsMenuFromRect:CGRectMake(455, 440, 100, 100) inView:self.view animated:YES];
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
