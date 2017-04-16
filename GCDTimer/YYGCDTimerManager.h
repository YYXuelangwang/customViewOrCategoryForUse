//
//  YYGCDTimerManager.h
//  JX_GCDTimer
//
//  Created by hundred wang on 17/4/1.
//  Copyright © 2017年 com.joeyxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYGCDTimerManager : NSObject

/**
 the interval 
 
 @discussion the interval of the dispatch_source_t, it will refect the
 all blocks
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 create instance of `YYGCDTimerManager`, with the interval, block;

 @param interval    the interval of the dispatch_source_t, it will refect the
                    all blocks
 @param repeat      whether perform repeat
 @param block       dispatch_block_t block
 @return            instance of `YYGCDTimerManager`
 */
+ (instancetype)timerManagerWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat eventHandle:(dispatch_block_t)block;

/**
 create instance of `YYGCDTimerManager`, with the interval, block;
 
 @param interval    the interval of the dispatch_source_t, it will refect the
                    all blocks
 @param delay       delay perform
 @param repeat      whether perform repeat
 @param block       dispatch_block_t block
 @return            instance of `YYGCDTimerManager`
 */
+ (instancetype)timerManagerWithInterval:(NSTimeInterval)interval delay:(NSTimeInterval)delay repeat:(BOOL)repeat eventHandle:(dispatch_block_t)block;
/**
 invilidate the dispatch_source_t, do `dispatch_source_cancel`
 */
- (void)invilidate;

/**
 add a block schemel once
 
 @param block       block
 @param flag        the block's flag, use to distinguish difference block
 */
- (void)addOnceBlock:(dispatch_block_t)block withFlag:(nullable NSString*)flag;

/**
 add a block schele repeat, with dispatch_time_t, the Default interval is 1;

 @param block       block
 @param interval    interval ,if you pass '0' ,will use the common interval
 */
- (void)addRepeatBlock:(dispatch_block_t)block withInterval:(NSTimeInterval)interval;

/**
 add a block schele repeat, with dispatch_time_t, the Default interval is 1;
 
 @param block       block
 @param interval    interval ,if you pass '0' ,will use the common interval
 @param flag the    block's flag, use to distinguish difference block
 */
- (void)addRepeatBlock:(dispatch_block_t)block withInterval:(NSTimeInterval)interval withFlag:(nullable NSString*)flag;

/**
 remove all the invoke blocks
 */
- (void)removeAllBlock;

/**
 remove the specified block

 @param flag        the block's flag, use to distinguish difference block
 */
- (void)removeBlockOfWhichFlag:(NSString*)flag;

@end

NS_ASSUME_NONNULL_END
