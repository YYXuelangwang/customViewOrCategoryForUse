//
//  PKUnreadMsgManager.h
//  Pokio
//
//  Created by langwang on 14/4/2021.
//  Copyright © 2021 深圳趣凡网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PKUnreadMsgType) {
    PUBLIC_NOTICE = 1,
};

@protocol PKUnreadMsgProtocol <NSObject>
@required
- (id _Nonnull )getKeyWords;
@end

@interface PKUnreadMsgStoredItem : NSObject
@property (assign, nonatomic) PKUnreadMsgType type;
@property (strong, nonatomic) NSString  * _Nonnull keyWords;
@end

NS_ASSUME_NONNULL_BEGIN

@interface PKUnreadMsgManager : NSObject
+ (instancetype)sharedInstance;
- (void)updateType:(PKUnreadMsgType)type msg:(id<PKUnreadMsgProtocol>)msg readed:(BOOL)readed;
- (void)updateTypeReaded:(PKUnreadMsgType)type;
- (NSUInteger)countOfType:(PKUnreadMsgType)type;
- (BOOL)checkMsgReadedType:(PKUnreadMsgType)type msg:(id<PKUnreadMsgProtocol>)msg;
- (NSArray<PKUnreadMsgStoredItem*>*)getItemsOfType:(PKUnreadMsgType)type;
@end

NS_ASSUME_NONNULL_END
