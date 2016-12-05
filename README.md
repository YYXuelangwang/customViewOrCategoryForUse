# customViewOrCategoryForUse
store my own view for use usually

## BtnTitleScrollView

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

![image](https://github.com/YYXuelangwang/customViewOrCategoryForUse/blob/master/chooseCalanderView.gif)
