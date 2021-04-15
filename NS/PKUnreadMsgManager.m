//
//  PKUnreadMsgManager.m
//  Pokio
//
//  Created by langwang on 14/4/2021.
//  Copyright © 2021 深圳趣凡网络科技有限公司. All rights reserved.
//

#import "PKUnreadMsgManager.h"
#import <FMDatabaseQueue.h>

@implementation PKUnreadMsgStoredItem
@end

@interface PKUnreadMsgManager()
@property (strong, nonatomic) FMDatabaseQueue  *queue;
@property (strong, nonatomic) NSString  *tableName;
@end

@implementation PKUnreadMsgManager
static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, keyWords, type) values (?, ?, ?)";
static NSString *const SELECT_SQL_WITH_CONDITION = @"SELECT * from %@ where %@";
static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";
static NSString *const DELETE_TYPE_SQL = @"DELETE from %@ where type = ?";

static PKUnreadMsgManager *manager;
+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[PKUnreadMsgManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbFileName = [NSString stringWithFormat:@"%@_pkUnreadMsg.sqlite", kUid];
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:dbFileName];
        self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        self.tableName = @"pkUnreadMsg";
        NSString *const CREATE_TABLE_SQL =
        @"CREATE TABLE IF NOT EXISTS pkUnreadMsg ( \
        id TEXT NOT NULL, \
        keyWords TEXT NOT NULL, \
        type INT NOT NULL, \
        PRIMARY KEY(id)) \
        ";
        __block BOOL result;
        [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
            result = [db executeUpdate:CREATE_TABLE_SQL];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDB:) name:KCHANGE_USER object:nil];
    }
    return self;
}

- (void)changeDB:(NSNotification*)noti{
    manager = [[PKUnreadMsgManager alloc] init];
}

- (NSString*)processKeyWords:(id)key{
    NSString *keyWords = [key description];
    if ([key isKindOfClass:[NSDictionary class]]) {
        keyWords = [(NSDictionary*)key toJsonString];
    }
    return keyWords;
}

- (void)updateType:(PKUnreadMsgType)type msg:(id<PKUnreadMsgProtocol>)msg readed:(BOOL)readed{
    NSString *keyWords = [self processKeyWords:[msg getKeyWords]];
    
    if (!keyWords) {return;}
    NSString * idS = [NSString stringWithFormat:@"%lu_%@", (unsigned long)type, keyWords];
    NSString * sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, self.tableName];
    if (readed) {
        sql = [NSString stringWithFormat:DELETE_ITEM_SQL, self.tableName];
    }
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (readed) {
            result = [db executeUpdate:sql, idS];
        }else{
            result = [db executeUpdate:sql, idS, keyWords, @(type)];
        }
    }];
}

- (void)updateTypeReaded:(PKUnreadMsgType)type{
    NSString *sql = [NSString stringWithFormat:DELETE_TYPE_SQL, self.tableName];
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db executeUpdate:sql, @(type)];
    }];
}

- (NSUInteger)countOfType:(PKUnreadMsgType)type{
    return [self getItemsOfType:type].count;
}

- (NSArray<PKUnreadMsgStoredItem *> *)getItemsOfType:(PKUnreadMsgType)type{
    NSString *condition = [NSString stringWithFormat:@"type = ?"];
    NSString *sql = [NSString stringWithFormat:SELECT_SQL_WITH_CONDITION, self.tableName, condition];
    __block NSMutableArray *result = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:sql, @(type)];
        while (set.next) {
            PKUnreadMsgStoredItem *item = [[PKUnreadMsgStoredItem alloc]  init];
            item.type = [set intForColumn:@"type"];
            item.keyWords = [set stringForColumn:@"keyWords"];
            [result addObject:item];
        }
        [set close];
    }];
    return result.count > 0 ? result : nil;
}

- (BOOL)checkMsgReadedType:(PKUnreadMsgType)type msg:(id<PKUnreadMsgProtocol>)msg{
    NSString *condition = [NSString stringWithFormat:@"id = ?"];
    NSString *sql = [NSString stringWithFormat:SELECT_SQL_WITH_CONDITION, self.tableName, condition];
    NSString *idS = [NSString stringWithFormat:@"%lu_%@", (unsigned long)type, [self processKeyWords:msg.getKeyWords]];
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:sql, idS];
        if ([set next]) {result = NO;}
        [set close];
    }];
    return result;
}

@end
