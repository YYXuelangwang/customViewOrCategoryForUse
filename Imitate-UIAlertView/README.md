# YYAlertView
imitate - UIAlertView

![image](https://github.com/YYXuelangwang/YYAlertView/blob/master/test.gif)

imitate - UIAlertVIew, so you can use YYAlertView like this 

    YYAlertView *alertView = [[YYAlertView alloc] initWithTitle:@"有道" message:@"Be slow to promise and quick to perform.   ---不轻诺，诺必果。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"slow",@"promise",@"perform",nil];
    [alertView show];

if you want to set the size of alertView just like this 

    YYAlertView *alertView = [[YYAlertView alloc] initWithTitle:@"有道" message:@"Be slow to promise and quick to perform.   ---不轻诺，诺必果。" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"slow",@"promise",@"perform",nil];
    
    //you don't need to care origin,like origin(1234,2342),size(200,200) all the same;
    alertView.containerFrame = CGRectMake(0, 100, 200, 200);
    [alertView show];

you can edit your own customerView all the same :

    YYAlertView *alertView = [[YYAlertView alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    view.backgroundColor = [UIColor whiteColor];
    alertView.customView = view;

note :  set customView, you need to set its frame, which you don't need to care about its origin; certainly you should add method hiddenAlertView in your event which you handle the event you want to hidden this alertView
