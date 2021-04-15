//
//  NSKeyValueObject.h
//  Pokio
//
//  Created by langwang on 12/3/2021.
//  Copyright © 2021 深圳趣凡网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKKeyValueObj : NSObject
@property (strong, nonatomic) id key;
@property (strong, nonatomic) id value;
@end

@interface NSMutableArray (PKKeyValueObj)
+ (NSMutableArray *(^)(id key, id value))setKeyValue;
- (NSMutableArray *(^)(id key, id value))setKeyValue;
- (PKKeyValueObj*(^)(NSInteger index))objAtIndex;
@end

NS_ASSUME_NONNULL_END

