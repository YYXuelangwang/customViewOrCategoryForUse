
###### this is a manager class for handle lots of blocks with dispatch_source_t

Characteristics of the manager:

* you can handle the block with difference duration
* you can add a block in the dispatch_source_t everytime you want
* you can delete the block which you has marked with the specified flag

note: once you want to destroy the manager or don't need to use it , you need to call the method `- (void)invilidate`;

###### how to use

demo:
1. add once time block;
```
- (IBAction)addOnceBlock:(id)sender {
    _number++;
    __weak typeof(self) weakSelf = self;
    [_manager addOnceBlock:^{
        NSLog(@"这是第%ld的block",weakSelf.number);
    } withFlag:NULL];
}
```
2. add repeat block with difference duration;
```
- (IBAction)addRepeatBlock:(id)sender {
    _number++;
    __weak typeof(self) weakSelf = self;
    [_manager addRepeatBlock:^{
        NSLog(@"这是第%ld的block",weakSelf.number);
    } withInterval:2 withFlag:NULL];
}
```
3. when you don't need to use the manager , you need to call method `- (void)invilidate`;
```
- (void)viewDidDisappear:(BOOL)animated{
    [_manager invilidate];
}
```
