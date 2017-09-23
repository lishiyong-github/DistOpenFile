//
//  FileProgressView.m
//  FileView
//
//  Created by shiyong_li on 2017/7/26.
//  Copyright © 2017年 shiyong_li. All rights reserved.
//

#import "FileProgressView.h"

#define kCColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0  blue:b/255.0  alpha:1]


@interface FileProgressView() {
    UILabel *labelTwo;
}


//创建全局属性
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer2;
@property (nonatomic, strong) CAShapeLayer *cicleLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float currentValue;
@property (nonatomic, assign) int  increase;
@property(nonatomic,  strong) UIView* roundView;
@property (nonatomic, assign) CGFloat increaseFloat;

@end
@implementation FileProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.lineWidth = 10.0f;
        [self addSubView];
    }
    return self;
}

#pragma mark - addSubView
- (void)addSubView
{
    [self addLayer1];
    [self addLayer2];
    [self addCircleLayer];
    [self addRoundView];
    [self addLabel];
}

- (void)addLayer1
{
    //创建出CAShapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.rect;
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    //创建出圆形贝塞尔曲线
    UIBezierPath* circlePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width / 2, self.rect.size.height / 2 )radius:self.rect.size.height / 2 startAngle:M_PI_2 endAngle:2.5*M_PI  clockwise:YES];
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    //添加并显示
    [self.layer addSublayer:self.shapeLayer];
}

- (void)addLayer2
{
    //创建出CAShapeLayer
    self.shapeLayer2 = [CAShapeLayer layer];
    self.shapeLayer2.frame = self.rect;
    
    self.shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    
    //设置线条的宽度和颜色
    self.shapeLayer2.lineWidth = self.lineWidth;
    self.shapeLayer2.strokeColor =  kCColor(0,174,239).CGColor;
    
    [self.layer addSublayer:self.shapeLayer2];
}

- (void)addCircleLayer
{
    //创建出CAShapeLayer
    self.cicleLayer = [CAShapeLayer layer];
    self.cicleLayer.frame = self.rect;
    
    self.cicleLayer.fillColor = [UIColor clearColor].CGColor;
    
    //设置线条的宽度和颜色
    self.cicleLayer.lineWidth = self.lineWidth;
    self.cicleLayer.strokeColor =  kCColor(0,174,239).CGColor;
    
    [self.layer addSublayer:self.cicleLayer];
}

- (void)addRoundView
{
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.center = CGPointMake(self.rect.size.width / 2, self.rect.size.height);
    view.layer.cornerRadius=10;
    view.layer.masksToBounds=YES;
    view.backgroundColor= kCColor(0,174,239);
    _roundView=view;
    [self addSubview:view];
}

- (void)addLabel {
    labelTwo = [[UILabel alloc] init];
    labelTwo.frame = CGRectMake(0,0,180,40);
    CGPoint point2 =  CGPointMake(self.shapeLayer.position.x, self.shapeLayer.position.y);
    labelTwo.center =  point2;
    labelTwo.text = @"0%";
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.font = [UIFont systemFontOfSize:50];
    labelTwo.textColor =  kCColor(0,174,239);
    [self addSubview:labelTwo];
}

#pragma mark - set percent
- (void)setHaveFinished:(float)haveFinished
{
    _strokeStart = self.haveFinished;
    _increase = 100*_strokeStart;
    self.increaseFloat = self.haveFinished - self.strokeStart;
    _haveFinished =  haveFinished;
    [self setNeedsDisplay];
}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect{
    [self startAnimation];
}

- (void)startAnimation {
    [self circleAnimationTypeOne];
    
    if (_haveFinished >0) {
        [self animation];
        
        CGFloat duration = 4 * self.increaseFloat;
        CGFloat count = 100*self.haveFinished - floorf(_increase);
        if (count>0){
            _timer = [NSTimer scheduledTimerWithTimeInterval:duration/count
                                                      target:self
                                                    selector:@selector(numShow)
                                                    userInfo:nil
                                                     repeats:YES];
        }
    }
    
}


- (void)circleAnimationTypeOne
{
    UIBezierPath* circlePath2=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width / 2, self.rect.size.height / 2 )radius:self.rect.size.height / 2 startAngle:M_PI_2 endAngle:2*M_PI*self.strokeStart+M_PI_2 clockwise:YES];
    
    self.shapeLayer2.path = circlePath2.CGPath;
    UIBezierPath* circlePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width / 2, self.rect.size.height / 2 )radius:self.rect.size.height / 2 startAngle:2*M_PI*self.strokeStart+ M_PI_2 endAngle:2*M_PI*_haveFinished+M_PI_2 clockwise:YES];
    self.cicleLayer.path = circlePath.CGPath;
}
- (void)animation {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 4*self.increaseFloat;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1];
    pathAnimation.autoreverses = NO;
    UIBezierPath* circlePath2=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width / 2, self.rect.size.height / 2 )radius:self.rect.size.height / 2 startAngle:2*M_PI*_strokeStart+M_PI_2 endAngle:2*M_PI*_haveFinished+M_PI_2 clockwise:YES];
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path=circlePath2.CGPath;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.calculationMode = kCAAnimationPaced;
    keyAnimation.duration = 4*self.increaseFloat;
    keyAnimation.removedOnCompletion = NO;
    [self.cicleLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    [_roundView.layer addAnimation:keyAnimation forKey:nil];
}

- (void) numShow {
    if (self.haveFinished < 0) {
        labelTwo.text = @"0%";
        [_timer invalidate];
        return;
    }
    else if (self.haveFinished <= 0.01) {
        labelTwo.text = @"1%";
        [_timer invalidate];
        return;
    }
    else if (_increase >=100*self.haveFinished) {
        [_timer invalidate];
        return;
    }
    else if (_increase == 100){
        [_timer invalidate];
        return;
    }
    _increase += 1;
    labelTwo.text = [NSString stringWithFormat:@"%d %%",_increase];
}

@end
