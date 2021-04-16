//
//  RollingNumView.m
//  GetBuryingData
//
//  Created by langwang on 24/8/2020.
//  Copyright © 2020 qufan. All rights reserved.
//

#import "RollingNumView.h"
#import "JackPotModel.h"

/* 修改动画参数，kReduceHeight：每帧上移高度；kReduceDt：每帧上移高度衰减高度（2.0-0.06）；kMaxReduceDt：每帧最大上移高度衰减高度（2.0 - 1.5） */
static const CGFloat kReduceHeight = 2.0;
static const CGFloat kReduceDt = 0.06;
static const CGFloat kMaxReduceDt = 1.5;

@interface RollingImageView : UIImageView
@property (assign, nonatomic) NSUInteger  value;
@property (strong, nonatomic) NSString  *preImageName;
@end

@implementation RollingImageView
- (void)setValue:(NSUInteger)value{
    _value = value;
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%ld", self.preImageName, value]]];
}

- (NSString *)preImageName{
    if (!_preImageName) {
        _preImageName = @"jackpot_num_";
    }
    return _preImageName;
}
@end

@interface RollingItem : UIView
{
    /* 每帧上移高度 */
    float   _reduce;
    /* 自己维护定时器的状态 */
    TIMERSTATUS    _status;
}

/* 是否是最后一圈 */
@property (assign, nonatomic) BOOL  finalRound;
/* 开始减速/衰减 */
@property (assign, nonatomic) BOOL  beginReduce;
/* 最终展示的数值，停止时的数值 */
@property (assign, nonatomic) int  stopValue;
/* 展示中的iv，大概3-4个 */
@property (strong, nonatomic) NSMutableArray<UIImageView*>  *ivs;
/* 缓存中的iv，超出指定区域后缓存下来的iv */
@property (strong, nonatomic) NSMutableArray<UIImageView*>  *cacheIvs;
/* 定时器 */
@property (strong, nonatomic) dispatch_source_t  timer;
/** 前一段图片名 */
@property (strong, nonatomic) NSString  *preImageName;
@end

@implementation RollingItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _status = TIMER_INACTIVE;
        _beginReduce = NO;
        [self initOthers];
    }
    return self;
}

- (void)initOthers{
    
    CGSize size = self.frame.size;
    
    self.layer.masksToBounds = YES;
    _reduce = 0;
    self.ivs = [NSMutableArray array];
    self.cacheIvs = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        RollingImageView *iv = [[RollingImageView alloc] init];
        iv.value = i;
        iv.frame = CGRectMake(0, -size.height + i * size.height, size.width, size.height);
        [self addSubview:iv];
        [self.ivs addObject:iv];
    }

}

- (void)setPreImageName:(NSString *)preImageName{
    _preImageName = preImageName;
    for (RollingImageView *iv in self.ivs) {
        iv.preImageName = preImageName;
    }
}

- (void)setStopValue:(int)stopValue{
    // change the value to the top RollingImageView's value;
    _stopValue = ((stopValue - 1) < 0) ? 9 : (stopValue - 1);
}

- (void)start{
    _beginReduce = NO;
    if (_status == TIMER_INACTIVE) {
        _status = TIMER_ACTIVE;
        dispatch_resume(self.timer);
    }
}

- (void)cancel{
    if (_status == TIMER_ACTIVE) {
        _status = TIMER_INACTIVE;
        dispatch_suspend(self.timer);
    }
    _reduce = 0;
//    _finalRound = NO;
}

- (void)dealloc{
    if (_timer) {
        if (_status == TIMER_INACTIVE) {dispatch_resume(_timer);}
        dispatch_source_cancel(_timer);
    }
}

- (void)updateStopValueWithoutAnimation:(NSUInteger)stopValue{
    self.stopValue = (int)stopValue;
    NSUInteger v = self.stopValue;
    for (RollingImageView *iv in self.ivs) {
        iv.value = v;
        v = v+1 >9 ? 0 : v+1;
    }
}

- (void)updateStopValueWithAnimation:(NSUInteger)stopValue{
    self.stopValue = (int)stopValue;
    _reduce = 0;
//    _finalRound = NO;
    [self start];
}

- (dispatch_source_t )timer{
    if (!_timer) {
        

        CGSize size = self.frame.size;
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 16*NSEC_PER_MSEC, 0);
        
        /* 定时器执行的block */
        MJWeakSelf
        dispatch_source_set_event_handler(_timer, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(strongSelf == nil) {return;}
                 RollingImageView *f = (RollingImageView *)strongSelf.ivs.firstObject;
                if (strongSelf->_finalRound) {
                    if (f.value == strongSelf.stopValue && f.frame.origin.y <= -size.height && f.frame.origin.y >= -size.height - kReduceHeight) {
                        [strongSelf cancel];
                        return;
                    }
                    if (f.value == (strongSelf.stopValue - 2 + 10)%10) {
                        strongSelf.beginReduce = YES;
                    }
                    if (strongSelf.beginReduce) {
                        strongSelf->_reduce += kReduceDt;
                        strongSelf->_reduce = strongSelf->_reduce > kMaxReduceDt ? kMaxReduceDt : strongSelf->_reduce;
                    }
                }
                for (UIImageView *iv in strongSelf.ivs) {
                    CGRect frame = iv.frame;
                    frame.origin.y -= (kReduceHeight - strongSelf->_reduce);
                    iv.frame = frame;
                }
               
                if (f.frame.origin.y < -size.height - kReduceHeight - 3) {
                    [strongSelf.ivs removeObject:f];
                    [strongSelf.cacheIvs addObject:f];
                }
                RollingImageView *l = (RollingImageView*)strongSelf.ivs.lastObject;
                if (l.frame.origin.y < 5) {
                    RollingImageView *iv = (RollingImageView*)strongSelf.cacheIvs.lastObject;
                    if (!iv) {
                        iv = [[RollingImageView alloc] initWithImage:[UIImage imageNamed:[@(arc4random()%9) description]]];
                        iv.preImageName = strongSelf.preImageName;
                        [strongSelf addSubview:iv];
                    }else{
                        [strongSelf.cacheIvs removeObject:iv];
                    }
                    CGRect rec = l.frame;
                    rec.origin.y += size.height;
                    iv.frame = rec;
                    iv.value = l.value + 1 > 9 ? 0 : (l.value + 1);
                    [strongSelf.ivs addObject:iv];
                }
            });
        });
    }
    return _timer;
}

@end



@interface RollingNumView()
{
    NSUInteger _length;
}
@property (strong, nonatomic) NSMutableArray<RollingItem*>  *items;
@end

@implementation RollingNumView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSpace = 0;
    }
    return self;
}

- (void)setOrignNumStr:(NSString *)orignNumStr{
    _orignNumStr = orignNumStr;
    if (!self.items) {
        /* 初始化每个item */
        self.items = [NSMutableArray array];
        const char *l = [orignNumStr UTF8String];
        for (int i = 0; i < orignNumStr.length; i++) {
            RollingItem *item = [[RollingItem alloc] initWithFrame:CGRectMake(i * (self.itemSize.width + self.itemSpace), 0, self.itemSize.width, self.itemSize.height)];
            [self addSubview:item];
            item.preImageName = self.preImageName;
            [item updateStopValueWithoutAnimation:l[i] - '0'];
            [self.items addObject:item];
        }
    }else{
        NSString *str = [self fixNumStr:orignNumStr WithMaxLength:self.items.count];
        const char *l = [str UTF8String];
        for (int i = 0; i < self.items.count; i++) {
            RollingItem *item = self.items[i];
            [item updateStopValueWithoutAnimation:l[i] - '0'];
        }
    }
}

- (void)updateValueWithAnimation:(NSString *)valueStr{
    NSString *str = [self fixNumStr:valueStr WithMaxLength:self.items.count];
    const char *l = [str UTF8String];
    for (int i = 0; i < self.items.count; i++) {
        RollingItem *item = self.items[i];
        item.finalRound = YES;
        [item updateStopValueWithAnimation:l[i] - '0'];
    }
}

/* 将数据进行修复到可以使用的程度：去掉‘.'；位数不够，前面用0替代； */
- (NSString *)fixNumStr:(NSString*)str WithMaxLength:(NSUInteger)length{
    NSString *ret = str;
    if ([str containsString:@"."]) {
        ret = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    int count = (int)ret.length;
    if (ret.length < length) {
        for (int i = 0; i < length - count; i++) {
            ret = [@"0" stringByAppendingString:ret];
        }
    }
    return ret;
}

@end
