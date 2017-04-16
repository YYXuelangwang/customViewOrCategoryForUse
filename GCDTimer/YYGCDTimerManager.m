//
//  YYGCDTimerManager.m
//  JX_GCDTimer
//
//  Created by hundred wang on 17/4/1.
//  Copyright © 2017年 com.joeyxu. All rights reserved.
//


#import "YYGCDTimerManager.h"
#import <objc/runtime.h>


@interface _YYBlockObject : NSObject{
    @package
    dispatch_block_t    _block;
    NSTimeInterval      _interval;
    NSTimeInterval      _calcuteTime;
    BOOL                _repeat;
    BOOL                _used;
}

//@property (nonatomic, assign) NSTimeInterval calcuteTime;

- (instancetype)initWithInterval:(NSTimeInterval)interval block:(dispatch_block_t)block repeat:(BOOL)repeat;
- (void)reset;
@end

@implementation _YYBlockObject

- (instancetype)initWithInterval:(NSTimeInterval)interval block:(dispatch_block_t)block repeat:(BOOL)repeat{
    self = [super init];
    if (self) {
        _interval       = interval;
        _calcuteTime    = interval;
        _block          = block;
        _repeat         = repeat;
        _used           = NO;
    }
    return self;
}

- (void)reset{
    _calcuteTime = _interval;
    _used = NO;
}

@end

static NSInteger suffix = 0;

static NSString* defaultFlag(){
    return [NSString stringWithFormat:@"defalutFlag+%ld", suffix++];
}

@interface YYGCDTimerManager(){
    dispatch_source_t   _source;
    dispatch_time_t     _time;
}

@end

@implementation YYGCDTimerManager

+ (instancetype)timerManagerWithInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeat:(BOOL)repeat eventHandle:(dispatch_block_t)block{
    return [[self alloc] initWithInterval:interval delay:delay repeat:repeat everntHandle:block];
}

+ (instancetype)timerManagerWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat eventHandle:(dispatch_block_t)block{
    return [[self alloc] initWithInterval:interval delay:0 repeat:repeat everntHandle:block];
}

- (void)setInterval:(NSTimeInterval)interval{
    if (interval < 0) return;
    _interval = interval;
    dispatch_source_set_timer(_source, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0);
}

- (instancetype)initWithInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeat:(BOOL)repeat everntHandle:(dispatch_block_t)block{
    self = [super init];
    if (self) {
        
        _interval = interval < 0 ? 0 : interval;
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        
        //store the blockObj
        _YYBlockObject *blockObj = [[_YYBlockObject alloc] initWithInterval:0 block:[block copy] repeat:repeat];
        NSMutableDictionary *dic = [self getStoredBlockDic];
        dic[defaultFlag()] = blockObj;
        dispatch_semaphore_t semaph = dispatch_semaphore_create(1);
        
        dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), _interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_source, ^{
            NSMutableDictionary *dic = [self getStoredBlockDic];
            NSLog(@"开始执行block==========");
            dispatch_semaphore_wait(semaph, DISPATCH_TIME_FOREVER);
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _YYBlockObject* _Nonnull obj, BOOL * _Nonnull stop) {
                if (obj->_repeat) {
                    
                    // has not use
                    if (!(obj->_used)) {
                        (obj->_block)();
                        obj->_used = YES;
                    }
                    
                    // calcuteTime reduce interval ,until calcuteTime less than zero;
                    obj->_calcuteTime -= _interval;
                    if (obj->_calcuteTime < 0) [obj reset];
                    
                }else if (!(obj->_used)){
                    (obj->_block)();
                    obj->_used = YES;
                }
            }];
            NSLog(@"执行完后block=========");
            dispatch_semaphore_signal(semaph);
        });
        dispatch_resume(_source);
    }
    return self;
}

- (void)invilidate{
    dispatch_source_cancel(_source);
    objc_setAssociatedObject(self, @selector(getStoredBlockDic), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#define addBlock(_interval_, _repeat_, _flag_)\
_YYBlockObject *blockObj = [[_YYBlockObject alloc] initWithInterval:_interval_ block:[block copy] repeat:_repeat_];\
NSMutableDictionary *dic = [self getStoredBlockDic];\
NSString *key = _flag_ ? _flag_ : defaultFlag();\
dic[key] = blockObj;

- (void)addOnceBlock:(dispatch_block_t)block withFlag:(NSString *)flag{
    addBlock(0, NO, flag);
}

- (void)addRepeatBlock:(dispatch_block_t)block withInterval:(NSTimeInterval)interval withFlag:(NSString *)flag{
    addBlock(interval, YES, flag);
}

- (void)addRepeatBlock:(dispatch_block_t)block withInterval:(NSTimeInterval)interval{
    [self addRepeatBlock:block withInterval:interval withFlag:NULL];
}

#undef addBlock

- (void)removeBlockOfWhichFlag:(NSString *)flag{
    if (!flag) return;
    NSMutableDictionary *dic = [self getStoredBlockDic];
    [dic removeObjectForKey:flag];
}

- (void)removeAllBlock{
    NSMutableDictionary *dic = [self getStoredBlockDic];
    [dic removeAllObjects];
}

- (NSMutableDictionary*)getStoredBlockDic{
    NSMutableDictionary *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        array = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

@end
