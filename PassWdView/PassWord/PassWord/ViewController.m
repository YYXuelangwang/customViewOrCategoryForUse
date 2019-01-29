//
//  ViewController.m
//  PassWord
//
//  Created by 钱范儿-Developer on 16/7/18.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "ViewController.h"

#import "YYPassWordView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CircleView *view = [[CircleView alloc
//                         ] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    view.touchLighted = YES;
//    view.number = 2;
//    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor colorWithRed:151 / 255.0 green:85 / 255.0 blue:121 / 255.0 alpha:0.5];
    
    YYPassWordView *passView = [[YYPassWordView alloc] initWithPassWord:@"12345"];
    [self.view addSubview:passView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
