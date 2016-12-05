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
