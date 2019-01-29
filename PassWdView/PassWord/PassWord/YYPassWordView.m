//
//  PassWordView.m
//  PassWord
//
//  Created by 钱范儿-Developer on 16/7/18.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "YYPassWordView.h"

//小点距离头部的高度
#define kDotsView_TopHeight 110

//触摸的1-9的大小
#define kTouchDotView_Width 68

#define kScreen_width [UIScreen mainScreen].bounds.size.width

#define kScreen_height [UIScreen mainScreen].bounds.size.height

#define kBlueColor [UIColor colorWithRed:62 / 255.0 green:165 / 255.0 blue:211 / 255.0 alpha:0.5]

@interface YYPassWordView(){
    UIView *_dotsView;
}

@property (nonatomic, strong) NSString *inputPassWd;

@end

@implementation YYPassWordView

- (instancetype)init{
    self = [super init];
    if (self ) {
        
    }
    return self;
}

/*
 * 这里重写inputPassWd的set方法，来实现inputPassWd的实时更新后对应的操作和验证；搭配self.inputPassWd来使用
 */
- (void)setInputPassWd:(NSString *)inputPassWd{
    
    NSString *str;
    if (!_inputPassWd) {
        str = inputPassWd;
    }else{
        str = inputPassWd.length > _inputPassWd.length ? inputPassWd : _inputPassWd;
    }
    
    _inputPassWd = inputPassWd;
    
    YYCircleView *circleView = (YYCircleView*)[_dotsView viewWithTag:100 + str.length - 1];
    circleView.lighted = !circleView.isLighted;
    
    if (inputPassWd.length == self.passWord.length) {
        [self verificationPassWd];
    }
}

#pragma mark - 验证输入的密码是否正确
- (void)verificationPassWd{
    if (![_inputPassWd isEqualToString:self.passWord]) {
        
        //为了动效我也是拼了，这个只是一个简单的demo，只是娱乐而用
        _dotsView.frame = CGRectMake(-30, kDotsView_TopHeight, kScreen_width, 10);
        
       [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
           
           _dotsView.frame = CGRectMake(0, kDotsView_TopHeight, kScreen_width, 10);
           
       } completion:^(BOOL finished) {
           for (YYCircleView *circleView in _dotsView.subviews) {
               circleView.lighted = NO;
           }
           _inputPassWd = [NSString string];
           
           if ([self.delegate respondsToSelector:@selector(passWordViewInputPassWordFailed:)]) {
               [self.delegate passWordViewInputPassWordFailed:self];
           }
           
       }];
        
    }else{
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(passWordViewInputPassWordSuccessed:)]) {
            [self.delegate passWordViewInputPassWordSuccessed:self];
        }
    }
}

#pragma mark - 初始化方法
- (instancetype)initWithPassWord:(NSString *)passWord{
    self = [super init];
    if (self) {
        self.passWord = passWord;
        
        _inputPassWd = [NSString string];
        
        [self setUpTitleLabel];
        
        [self setUpDatViewWithLength:passWord.length];
        
        [self setUpTouchDotView];
        
        [self setUpCancelButton];
        
        
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

#pragma mark - 设置标题
- (void)setUpTitleLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, 30)];
    
    label.text = @"请输入密码";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:22];
    label.textColor = [UIColor whiteColor];
    
    [self addSubview:label];
}

#pragma mark - 设置小点的视图，有点像pageController
- (void)setUpDatViewWithLength:(NSInteger)length{
    
    _dotsView = [[UIView alloc] initWithFrame:CGRectMake(0, kDotsView_TopHeight, kScreen_width, 10)];
    
    CGFloat margin = (length - 8) * (length - 8) * 3.0;
    CGFloat width = 10;
    
    CGFloat edageSide = (kScreen_width - length * (margin + width) + margin) / 2;
    
    YYCircleView *lastCircleView;
    for (int i = 0; i < length; i ++) {
        YYCircleView *circleView;
        if (i == 0) {
            circleView = [[YYCircleView alloc]initWithFrame:CGRectMake(edageSide, 0, width, width)];
        }else{
            circleView = [[ YYCircleView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastCircleView.frame) + margin, 0, width, width)];
        }
        
        lastCircleView = circleView;
        circleView.tag = 100 + i;
        
        [_dotsView addSubview:circleView];
    }
    
    
    
    [self addSubview:_dotsView];
    
}

#pragma mark - 设置点击的数字视图，1-9；
- (void)setUpTouchDotView{
    
    CGFloat width = kTouchDotView_Width;
    
    CGFloat margin = (kScreen_width - 3 * width ) / 4.0;
    
    UIView *touchDotsView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kScreen_width, kScreen_width - margin + width)];
    
    YYCircleView *lastCircleView;
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 3; j ++) {
            YYCircleView *circleView;
            if (j == 0) {
                circleView = [[YYCircleView alloc] initWithFrame:CGRectMake(margin, i * (margin + width), width, width)];
            }else{
                circleView = [[YYCircleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastCircleView.frame) + margin, i * (margin + width), width, width)];
            }
            lastCircleView = circleView;
            
            circleView.touchLighted = YES;
            
            circleView.number = i * 3 + j + 1;
            
            /*设置block来存储点击的数字，最后用来验证是否输入正确密码*/
            __weak typeof(self) unself = self;
            circleView.touchEvent = ^(NSInteger number){
               unself.inputPassWd = [unself.inputPassWd stringByAppendingFormat:@"%ld",(long)number];
            };
            
            [touchDotsView addSubview:circleView];
        }
    }
    
    YYCircleView *zeroCircleView = [[YYCircleView alloc] initWithFrame:CGRectMake(margin * 2 + width, (margin + width ) * 3.0, width, width)];
    zeroCircleView.touchLighted = YES;
    zeroCircleView.number = 0;
    
    /*设置block来存储点击的数字，最后用来验证是否输入正确密码*/
    __weak typeof(self) unself = self;
    
    zeroCircleView.touchEvent =  ^(NSInteger number){
        unself.inputPassWd = [unself.inputPassWd stringByAppendingFormat:@"%ld",(long)number];
    };
    
    [touchDotsView addSubview:zeroCircleView];
    
    [self addSubview:touchDotsView];
    
}

- (void)setUpCancelButton{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_width - 100, kScreen_height - 60, 100, 40)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelLastInput) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
}


- (void)cancelLastInput{
    if (self.inputPassWd.length >= 1) {
        self.inputPassWd = [self.inputPassWd substringToIndex:self.inputPassWd.length - 1];
    }
}

@end


@interface YYCircleView(){
    CAShapeLayer *_circleShapeLayer;
}

@end

@implementation YYCircleView


#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5) radius:frame.size.width * 0.5 - 1 startAngle:0  endAngle:M_PI * 2 clockwise:YES];
        
        _circleShapeLayer = [CAShapeLayer layer];
        _circleShapeLayer.path = path.CGPath;
        _circleShapeLayer.strokeColor = kBlueColor.CGColor;
        _circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_circleShapeLayer];
        
        _touchLighted = NO;
        
    }
    return self;
}

#pragma mark - 设置是否填充颜色
- (void)setLighted:(BOOL)lighted{
    _lighted = lighted;
    
    _circleShapeLayer.fillColor = _lighted ? kBlueColor.CGColor : [UIColor clearColor].CGColor;
}

#pragma mark - 设置需要显示的数字
- (void)setNumber:(NSInteger)number{
    _number = number;
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont systemFontOfSize:self.bounds.size.width * 0.6];
    label.text = [NSString stringWithFormat:@"%ld",(long)number];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}

#pragma mark - 设置是否需要实现触摸后填充颜色
- (void)setTouchLight:(BOOL)touchLighted{
    _touchLighted = touchLighted;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_touchLighted) {
        self.lighted = YES;
        if (_touchEvent) {
            _touchEvent(_number);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bounds, pt) && _touchLighted) {
        self.lighted = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_touchLighted) {
        self.lighted = NO;
    }
    
}

@end
