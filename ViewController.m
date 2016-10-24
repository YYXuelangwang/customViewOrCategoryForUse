//
//  ViewController.m
//  CustomTitleBtnsView
//
//  Created by yinyong on 16/10/20.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "ViewController.h"
#import "XRDTitleBtnScrollView.h"




@interface ViewController ()<UIScrollViewDelegate, XRDTitleBtnScrollViewDelegate>

@property (nonatomic, strong) XRDTitleBtnScrollView *titleBtnView;

@property (nonatomic, strong) UIScrollView *detailScrollVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initUI];
    
    // Do any additional setup after loading the view.
}


- (void)initUI{
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    self.titleBtnView = [[XRDTitleBtnScrollView alloc] initWithFrame:CGRectMake(0, 60, width, 40) withTitleArray:@[@"奥给俺二哥", @"奥格好好", @"aogieoighaoeg", @"奥格荷坳哈珀"] withFontSize:13];
    [self.view addSubview:self.titleBtnView];
    
    self.detailScrollVIew  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, width, height - 100)];
    self.detailScrollVIew.contentSize = CGSizeMake(width * 4, height - 100);
    self.detailScrollVIew.pagingEnabled = YES;
    for ( int i = 0; i < 4; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, height - 100)];
        view.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() %256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1.0];
        [self.detailScrollVIew addSubview:view];
    }
    [self.view addSubview:self.detailScrollVIew];
    
    self.detailScrollVIew.delegate = self;
    self.titleBtnView.xrdDelegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.titleBtnView scrollTitleBtnScrollViewWithScrollVIew:scrollView withScrollDistance:scrollView.contentOffset.x];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger width = scrollView.frame.size.width;
    NSInteger index = scrollView.contentOffset.x / width;
    self.titleBtnView.selectedTitleIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
