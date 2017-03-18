# customViewOrCategoryForUse
store my own view for use usually

## BtnTitleScrollView

- How to use
- 1，you need to drug the XRDTitleBtnScrollView file to your project;
- 2，set the view's frame , titleArray and xrdDelegate;

```objective-c
    self.titleBtnScrollView = [[XRDTitleBtnScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) withTitleArray:self.titleArray withFontSize:16];
    self.titleBtnScrollView.backgroundColor = [UIColor whiteColor];
    self.titleBtnScrollView.xrdDelegate = self;
    [self.view addSubview:self.titleBtnScrollView];
```

- 3，you can do what you want in the protocol method

```objective-c
@protocol XRDTitleBtnScrollViewDelegate <NSObject>

@optional

//when titleBtn clicked
- (void)handleEventWhenTitleBtnClicked:(UIButton*)button withTitleIndex:(NSInteger)titleIndex;

//when titleBtn will be clicked
- (void)handleEventWhenTitleBtnBeginBeClicked:(UIButton*)button withTitleIndex:(NSInteger)titleIndex;

@end
```

![image](https://github.com/YYXuelangwang/customViewOrCategoryForUse/blob/master/titleBtnMovie.gif)

## ChooseCalanderView

- How to use
- 1, you need to drug the calanderView document to your project;
- 2, you set the view's frame and delegate 

```objective-c
        YYChooseCalanderView *_chooseCalanderView = [[YYChooseCalanderView alloc] initWithFrame:self.view.bounds];
        _chooseCalanderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _chooseCalanderView.delegate = self;
        //set the view current selectedDate; Default is now;
        _chooseCalanderView.selectedDate = [NSDate date]; 
```

- 3，you can get you choose calander from protocol method

```objective-c
@protocol YYChooseCalanderViewDelegate <NSObject>

//get the choosed date
- (void)CalanderView:(YYChooseCalanderView*)view didChangeSelectedDate:(NSDate*)selectedDate;

@end
```
![image](https://github.com/YYXuelangwang/customViewOrCategoryForUse/blob/master/chooseCalanderView.gif)

## LTRootViewController+ltNav

- How to use 
- 1, you need to drug the ltNav document to your project;
- 2, look,  you just need to call addNavView in the -init implement;
- 3, here is the code

```objective-c

#import "LTRootViewController+LTNavView.h"

@implementation TestViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNavView];
    }
    return self;
}
```
- 4, you need to know that i recovery the method in the viewDidDisappeared, it's not good

```objective-c
/* because this class Inherited from UIViewController，and this method will cover the code from LTRootViewController;
    or you can creat a new method to compile this code;
    因为是继承自UIViewController，所以这里可以调用[super viewDidDisappear:animated]; 还有，这样写了后，会覆盖原类的相关方法
    如果可以，还是建议新建一个方法来实现下面的方法，从而实现复原method的指针指向；
*/
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
```
![image](https://github.com/YYXuelangwang/customViewOrCategoryForUse/blob/master/LTNav/ltNav.gif)
