//
//  ViewController.m
//  imitate-UIAlertView
//
//  Created by 钱范儿-Developer on 16/6/15.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "ViewController.h"
#import "YYAlertView.h"

@interface ViewController ()<YYAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (IBAction)click:(id)sender {
    YYAlertView *alertView = [[YYAlertView alloc] initWithTitle:@"有道" message:@"Be slow to promise and quick to perform.   ---不轻诺，诺必果。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"slow",@"promise",@"perform",nil];
    [alertView show];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [alertView show];
//    });
    
}

- (IBAction)alerViewWithDefinedFrame:(id)sender {
    YYAlertView *alertView = [[YYAlertView alloc] initWithTitle:@"有道" message:@"Be slow to promise and quick to perform.   ---不轻诺，诺必果。" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"slow",@"promise",@"perform",nil];
    
    //you don't need to care origin,like origin(1234,2342),size(200,200) all the same;
    alertView.containerFrame = CGRectMake(0, 100, 200, 200);
    [alertView show];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [alertView show];
//    });
}


- (IBAction)customViewClick:(id)sender {
    YYAlertView *alertView = [[YYAlertView alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    view.backgroundColor = [UIColor whiteColor];
    alertView.customView = view;
    [self handlCustomView:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCustomView:)];
    [view addGestureRecognizer:tap];
    
    [alertView show];
}

- (void)hiddenCustomView:(UITapGestureRecognizer*)tap{
    YYAlertView *superView = (YYAlertView*)tap.view.superview;
    [superView hiddenAlertView];
}

- (void)handlCustomView:(UIView *)view{
    
    UIImage *image = [UIImage imageNamed:@"test"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(10, (150 - 78) * 0.5, 55, 78);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, (150 - 78) * 0.5 - 10, 300 - 85, 78 + 20)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"After he slapped two soldiers, US Lieutenant General George S. Patton was sidelined from combat command by General Dwight Eisenhower and Army Chief of Staff George C. Marshall. On 3 August 1943, during the Sicily Campaign of World War II, Patton struck, kicked and berated a soldier he found at an evacuation ...";
    [view addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
