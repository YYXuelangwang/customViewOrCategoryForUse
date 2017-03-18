//
//  LTRootViewController+LTNavView.m
//  PlantHunter
//
//  Created by hundred wang on 17/3/17.
//  Copyright © 2017年 One23S. All rights reserved.
//

#import "LTRootViewController+LTNavView.h"


static char const *const kImpDic = "impDic";

@interface LTRootViewController ()

@property (nonatomic, readonly) NSDictionary * impDic;

@end

@implementation LTRootViewController (LTNavView)

- (void)addNavView{
    [self swizzle];
}

- (NSDictionary *)impDic{
    NSDictionary *dic = objc_getAssociatedObject(self, kImpDic);
    if (!dic) {
        dic = [NSDictionary dictionary];
        objc_setAssociatedObject(self, kImpDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (UIView *)lt_NavView{
    UIView *navView = objc_getAssociatedObject(self, _cmd);
    
    if (!navView) {
        navView = [self lt_creatNavView];
        objc_setAssociatedObject(self, _cmd, navView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return navView;
}

- (UIView*)lt_creatNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 22, 24)];
    [navView addSubview:backBtn];
    
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(lt_backVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [UIColor clearColor];
    
    return navView;
}

- (BOOL)lt_isPop{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.lt_isPop = YES;
    return YES;
}

- (void)setLt_isPop:(BOOL)lt_isPop{
    SEL key = @selector(lt_isPop);
    objc_setAssociatedObject(self, key, @(lt_isPop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_backVC{
    if (self.navigationController) {
        if (self.lt_isPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lt_addNavView{
    [self.view addSubview:self.lt_NavView];
}


static NSMutableDictionary *_lt_impDic; //存储orign的imp指针的数组
static NSString *const LTSwizzleOrignViewDidLoadKey = @"viewDidLoad";

- (void)swizzle{
    
    if (!_lt_impDic) {
        _lt_impDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    Method method = class_getInstanceMethod(self.class, @selector(viewDidLoad));
    
    IMP lt_orignImplementation = method_setImplementation(method, (IMP)lt_new_implementation);
    
    NSString *className = NSStringFromClass(self.class);
    NSDictionary *dic = @{LTSwizzleOrignViewDidLoadKey : [NSValue valueWithPointer:lt_orignImplementation]};
    
    //将self。class座位key，存储原始的imp
    [_lt_impDic setObject:dic forKey:className];
    
}

void lt_new_implementation(id self, SEL _cmd)
{
    NSDictionary *dic = [_lt_impDic objectForKey:NSStringFromClass([self class])];
    
    NSValue *impValue = [dic objectForKey:LTSwizzleOrignViewDidLoadKey];
    IMP impPoint = [impValue pointerValue];
    
    if (impPoint) {
        ((void(*)(id,SEL))impPoint)(self, _cmd);
    }
    
    [self lt_addNavView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //除掉其他控制器的调用
    if (!self.lt_NavView) {
        return;
    }
    
    Method method = class_getInstanceMethod(self.class, @selector(viewDidLoad));
    
    //还原原始的imp
    NSDictionary *dic = [_lt_impDic objectForKey:NSStringFromClass(self.class)];
    NSValue *impValue = [dic objectForKey:LTSwizzleOrignViewDidLoadKey];
    if (!impValue) {
        return;
    }
    
    IMP impPoint = [impValue pointerValue];
    method_setImplementation(method, impPoint);
    
    //移除暂时不用的object
    [_lt_impDic removeObjectForKey:NSStringFromClass(self.class)];
}

@end
