//
//  IPSDatabaseManager.h
//  XESIPS
//
//  Created by JXT on 16/4/29.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 为可能的外部数据库操作提供函数接口
#import "FMDatabase.h"
#import "NSObject+Empty.h"

//写入时间戳
static inline NSNumber * timeIntervalForDB() {
    return @((NSInteger)([[NSDate date] timeIntervalSince1970]*1000+0.5));
}

@interface DatabaseManager : NSObject

/**
 *  获取操作对象
 *
 *  @return 本类对象
 */
+ (DatabaseManager *)sharedDBManager;

/**
 *  建表
 *
 *  @param tableName 表名
 *  @param fieldDict 数据库表的字段名（不包含主键，key-->字段名，value-->字段数据类型）
 */
- (void)createTableWithName:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict;

/**
 *  删表
 *
 *  @param tableName 表名
 */
- (void)dropTableWithName:(NSString *)tableName;

/**
 *  插入数据
 *
 *  @param tableName 表名
 *  @param fieldDict 数据模型的key-value，不支持%@表示NSData
 */
- (void)insertDataToTable:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict;

/**
 *  删除数据
 *
 *  @param tableName 表名
 *  @param fieldDict key-value
 */
- (void)deleteDataFromTable:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict;

/**
 *  删除数据
 *
 *  @param tableName 表名
 *  @param keyString keyString
 */
- (void)deleteDataFromTable:(NSString *)tableName byKeyString:(NSString *)keyString;


/**
 *  单条件查询数据
 *
 *  @param tableName 数据库表名
 *  @param name      字段名（当字段名为空时nil，查询并返回数据库所有数据）
 *  @param value     字段值
 *  @param keyArray  要查询的字段名(键)数组
 *
 *  @return 查询结果数组
 */
- (NSMutableArray *)selectDatasFromTable:(NSString *)tableName byParaName:(NSString *)name paraValue:(id)value andCollectByKeys:(NSArray *)keyArray;

/**
 *  多条件查询
 *
 *  @param tableName 表名
 *  @param fieldDict key-value
 *  @param keyArray  查询结果的的key
 *
 *  @return 装字典的数组，字典为key何value
 */
- (NSArray *)selectDatasFromTable:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict andCollectByKeys:(NSArray *)keyArray;

/**
 *  修改单条数据
 *
 *  @param tableName 数据库表名
 *  @param dict      要修改数据的表达式条件key-value  （一对key-value）
 *  @param dict2     待修改的字段key-value  （一对key-value）
 */
- (void)updateTable:(NSString *)tableName paraDict:(NSDictionary *)dict newParaDict:(NSDictionary *)dict2;


/**
 *  根据时间戳删除对应数据
 *
 *  @param tableName 表名
 *  @param keyPath   时间戳字段名
 *  @param second    时间限制，超过此时间限制的将删除，单位秒
 */
- (void)deleteDatasFromTable:(NSString *)tableName withTimeIntervalKeyPath:(NSString *)keyPath andTimeAgoInSecond:(NSTimeInterval)second;

@end
