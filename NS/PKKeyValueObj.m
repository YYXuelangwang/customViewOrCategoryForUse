//
//  NSKeyValueObject.m
//  Pokio
//
//  Created by langwang on 12/3/2021.
//  Copyright © 2021 深圳趣凡网络科技有限公司. All rights reserved.
//

#import "PKKeyValueObj.h"

@implementation PKKeyValueObj

+ (PKKeyValueObj*)createWithKey:(id)key value:(id)value{
    PKKeyValueObj *obj = [[PKKeyValueObj alloc] init];
    obj.key = key;
    obj.value = value;
    return obj;
}

@end

@implementation NSMutableArray (PKKeyValueObj)

- (NSMutableArray * _Nonnull (^)(id _Nonnull key, id _Nonnull value))setKeyValue{
    return ^(id key, id value){
        [self addObject:[PKKeyValueObj createWithKey:key value:value]];
        return self;
    };
}

+ (NSMutableArray * _Nonnull (^)(id _Nonnull, id _Nonnull))setKeyValue{
    return [[[NSMutableArray alloc] init] setKeyValue];
}

- (PKKeyValueObj * _Nonnull (^)(NSInteger))objAtIndex{
    return ^(NSInteger index){
        return (PKKeyValueObj*)self[index];
    };
}

@end
