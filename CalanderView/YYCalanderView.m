//
//  YYSecondCalanderView.m
//  testCalendar
//
//  Created by 钱范儿-Developer on 16/11/8.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "YYCalanderView.h"
#import "NSDate+Calcute.h"
#import "YYCalanderCell.h"

static NSString *reuseIdetifi = @"cell";
static NSInteger   totalItemsCount = 100;

@interface YYCalanderView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation YYCalanderView

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.bounds = CGRectMake(0, 0, 35, 35);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 35, 35)];
        _circleLayer.path = path.CGPath;
        _circleLayer.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((unitWidth + 5) * 7 + 5, (unitHeight + 5) * 5 + 5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[YYCalanderCell class] forCellWithReuseIdentifier: reuseIdetifi];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpSubView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDate:) name:YYCALANDERCELL_BUTTONCLICKED_NOTIFICATION object:nil];
    }
    return self;
}

- (void)setUpSubView{
    
    self.frame = CGRectMake(0, 0, (unitWidth + 5) * 7 + 5, (unitHeight + 5) * 5 + 5 + 35);
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    //添加上面的星期
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 35)];
    greenView.backgroundColor = NavColor;
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < array.count ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 + (unitWidth + 5) * i, 5, unitWidth, unitHeight)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        [greenView addSubview:label];
    }
    [self addSubview:greenView];
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(greenView.frame), (unitWidth + 5) * 7 + 5, (unitHeight + 5) * 5 + 5);
    [self addSubview:self.collectionView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.collectionView.contentOffset.x == 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YYCalanderCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetifi forIndexPath:indexPath];
    NSInteger monthIndex = indexPath.item - totalItemsCount * 0.5;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:monthIndex];
    [components setDay:1];
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.selectedDate options:0];
    
    cell.calcuteDate = date;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //在结束的时候让circleLayer滚动到每个月的第一天
    if (self.collectionView == scrollView) {
        NSInteger item = (NSInteger)((self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5) / self.collectionView.bounds.size.width);
        YYCalanderCell * cell = (YYCalanderCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
//        CGRect rect = [self convertRect:cell.firstDayButtonFrame fromView:cell];
//        self.circleLayer.position = CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.5);
        [cell chooseFirstDayButton];
    }
}

#pragma mark - monitorNotification

- (void)selectedDate:(NSNotification*)notifi{
    CGRect buttonRect = [notifi.userInfo[USERINFO_BUTTON_FRAME_KEY] CGRectValue];
    YYCalanderCell *cell = (YYCalanderCell*)notifi.userInfo[USERINFO_ITEM_KEY];
    
    //这里如果使用转换rect；那么选择的fromView只能选择item；如果选择collectionView，系统就会把contentoffSet计算进去
    CGRect rect = [self convertRect:buttonRect fromView:cell];
    self.circleLayer.position = CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.5);
    NSDate *selectedDate = notifi.userInfo[USERINFO_SELECTED_DATE_KEY];
    self.finialSelectedDate = selectedDate;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
