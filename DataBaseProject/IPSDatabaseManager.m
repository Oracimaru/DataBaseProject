//
//  IPSDatabaseManager.m
//  XESIPS
//
//  Created by JXT on 16/4/29.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "IPSDatabaseManager.h"

#import "FMDatabaseAdditions.h"

//定义本工程所使用的数据库路径
#define kDatabaseFilePath    [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]
#define kDatabaseFileName @"Database.db"

static IPSDatabaseManager * _ipsDatabase = nil;

@implementation IPSDatabaseManager
{
    //全局的FMDatabase对象
    FMDatabase * _database;
    //线程锁
    NSLock * _lock;
}

#pragma mark - Init
+ (IPSDatabaseManager *)sharedDBManager
{
    //考虑多线程，不允许多条线程同时调用
    @synchronized(self) {
        if (_ipsDatabase == nil) {
            _ipsDatabase = [[self alloc] initWithDBFileName:kDatabaseFileName];
        }
    }
    return _ipsDatabase;
}

- (instancetype)initWithDBFileName:(NSString *)name
{
    if (self = [super init]) {
        //自定义操作
        //实例化_database对象
        _database = [[FMDatabase alloc] initWithPath:[kDatabaseFilePath stringByAppendingPathComponent:name]];
        NSLog(@"数据库文件路径:%@", [kDatabaseFilePath stringByAppendingPathComponent:name]);
        
        //打开数据库
        [_database open];
        
        //初始化线程锁
        _lock = [[NSLock alloc] init];
    }
    return self;
}

#pragma mark - Methods
#pragma mark -建表
- (void)createTableWithName:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    if (![_database tableExists:tableName]) {  //如果表不存在
        //容错
        if (![fieldDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"数据类型错误，非字典");
            return ;
        }
        
        //加锁
        [_lock lock];
        
        NSMutableString * sqlContent = [NSMutableString string];
        int i = 0;
        for (NSString * key in fieldDict) {
            if (i == 0) {//注意逗号！
                [sqlContent appendFormat:@"%@ %@", key, fieldDict[key]];
            }
            else
            {
                [sqlContent appendFormat:@", %@ %@", key, fieldDict[key]];
            }
            i ++;
        }
        
        NSString * sql = [NSString stringWithFormat:@"create table if not exists %@(table_id integer primary key autoincrement, %@)", tableName, sqlContent];
        
        //执行sql语句
        BOOL bo = NO;
//        @synchronized(_database) {
            bo = [_database executeUpdate:sql];
//        }
        NSLog(@"建表语句:%@", sql);
        
        if (!bo) {
            NSLog(@"创建表失败：%@", _database.lastErrorMessage);
        }
        //解锁
        [_lock unlock];
    }
    else {
        NSLog(@"%@表已存在，不再创建", tableName);
    }
}

#pragma mark -删表
- (void)dropTableWithName:(NSString *)tableName
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    [_lock lock];
    NSString * sql = [NSString stringWithFormat:@"drop table %@", tableName];
    
    BOOL bo = NO;
//    @synchronized(_database) {
        bo = [_database executeUpdate:sql];
//    }
    NSLog(@"删表语句:%@", sql);
    
    if (!bo) {
        NSLog(@"删表失败：%@", _database.lastErrorMessage);
    }
    [_lock unlock];
}

#pragma mark -插入数据
//仅限%@型！！！
- (void)insertDataToTable:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    [_lock lock];
    
    NSMutableString * sqlContent1 = [NSMutableString string];
    int i = 0;
    for (NSString * key in fieldDict) {
        if (i == 0) {
            [sqlContent1 appendFormat:@"%@", key];
        }
        else
        {
            [sqlContent1 appendFormat:@", %@", key];
        }
        i ++;
    }
    
    NSMutableString * sqlContent2 = [NSMutableString string];
    int j = 0;
    for (NSString * key in fieldDict) {
        if (j == 0) {
            
            if ([fieldDict[key] isKindOfClass:[NSString class]]) {
                [sqlContent2 appendFormat:@"'%@'", [NSString safeString:fieldDict[key]]];
            }
            else
            {
                if ([NSObject empty:fieldDict[key]]) {
                    [sqlContent2 appendFormat:@"%@", NULL];
                }
                else
                {
                    [sqlContent2 appendFormat:@"%@", fieldDict[key]];
                }
            }
        }
        else
        {
            if ([fieldDict[key] isKindOfClass:[NSString class]]) {
                [sqlContent2 appendFormat:@", '%@'", [NSString safeString:fieldDict[key]]];
            }
            else
            {
                if ([NSObject empty:fieldDict[key]]) {
                    [sqlContent2 appendFormat:@", %@", NULL];
                }
                else
                {
                    [sqlContent2 appendFormat:@", %@", fieldDict[key]];
                }
            }
        }
        j ++;
    }
    
    //组装sql语句
    NSString * sql = [NSString stringWithFormat:@"insert into %@(%@) values(%@)", tableName, sqlContent1, sqlContent2];
    
    BOOL bo = NO;
//    @synchronized(_database) {
        bo = [_database executeUpdate:sql];
//    }
    NSLog(@"插入数据:%@", sql);
    if (!bo) {
        NSLog(@"插值错误：%@", _database.lastErrorMessage);
    }

    [_lock unlock];
}

#pragma mark -删除数据
- (void)deleteDataFromTable:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    [_lock lock];
    
    NSMutableString * sqlContent = [NSMutableString string];
    int i = 0;
    for (NSString * key in fieldDict) {
        if (i == 0) {//注意逗号！
            if ([fieldDict[key] isKindOfClass:[NSString class]]) {
                [sqlContent appendFormat:@"%@ = '%@'", key, fieldDict[key]];
            }
            else {
                [sqlContent appendFormat:@"%@ = %@", key, fieldDict[key]];
            }
        }
        else
        {
            if ([fieldDict[key] isKindOfClass:[NSString class]]) {
                [sqlContent appendFormat:@" and %@ = '%@'", key, fieldDict[key]];
            }
            else {
                [sqlContent appendFormat:@" and %@ = %@", key, fieldDict[key]];
            }
        }
        i ++;
    }
    
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@", tableName, sqlContent];
    
    BOOL bo = NO;
//    @synchronized(_database) {
        bo = [_database executeUpdate:sql];
//    }
    NSLog(@"删除:%@", sql);
    
    if (!bo) {
        NSLog(@"删除失败：%@", _database.lastErrorMessage);
    }
    
    [_lock unlock];
}
- (void)deleteDataFromTable:(NSString *)tableName byKeyString:(NSString *)keyString{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    [_lock lock];
    
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@", tableName, keyString];
    
    BOOL bo = NO;
    //    @synchronized(_database) {
    bo = [_database executeUpdate:sql];
    //    }
    NSLog(@"删除:%@", sql);
    
    if (!bo) {
        NSLog(@"删除失败：%@", _database.lastErrorMessage);
    }
    
    [_lock unlock];
}

#pragma mark -单条件查询数据
- (NSMutableArray *)selectDatasFromTable:(NSString *)tableName byParaName:(NSString *)name paraValue:(id)value andCollectByKeys:(NSArray *)keyArray
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return nil;
    }
    
    [_lock lock];
    
    FMResultSet * result = nil;
    
    if (name == nil) {
        //全查
        NSString * sql = [NSString stringWithFormat:@"select * from %@", tableName];
        
//        @synchronized(_database) {
            result = [_database executeQuery:sql];
//        }
        NSLog(@"全查:select * from %@", tableName);
    }
    else
    {
        //特定值查询
        NSString * sql = [NSString stringWithFormat:@"select * from %@ where %@ = ?", tableName, name];
        
//        @synchronized(_database) {
            result = [_database executeQuery:sql, value];
//        }
        NSLog(@"条件查:select * from %@ where %@ = ?", tableName, name);
    }
    
    NSMutableArray * array = [NSMutableArray array];
    
    while ([result next]) {
        
        NSMutableArray * objcArr = [NSMutableArray array];
        
        for (NSString * key in keyArray) {
            id object = [result objectForColumnName:key];
            [objcArr addObject:object];
        }
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:objcArr forKeys:keyArray];
        
        [array addObject:dict];
    }
    [result close];
    
    [_lock unlock];
    
    return array;
}

#pragma mark -多条件查询数据
- (NSArray *)selectDatasFromTable:(NSString *)tableName byKeyValueDict:(NSDictionary *)fieldDict andCollectByKeys:(NSArray *)keyArray
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return nil;
    }
    
    [_lock lock];
    
    FMResultSet * result = nil;
    
    NSMutableString * sqlContent = [NSMutableString string];
    int i = 0;
    for (NSString * key in fieldDict) {
        if (i == 0) {
            if ([fieldDict[key] isKindOfClass:[NSString class]]) {
                [sqlContent appendFormat:@"%@ = '%@'", key, fieldDict[key]];
            }
            else {
                [sqlContent appendFormat:@"%@ = %@", key, fieldDict[key]];
            }
        }
        else
        {
            if ([fieldDict[key] isKindOfClass:[NSString class]]) {
                [sqlContent appendFormat:@" and %@ = '%@'", key, fieldDict[key]];
            }
            else {
                [sqlContent appendFormat:@" and %@ = %@", key, fieldDict[key]];
            }
        }
        i ++;
    }
    
    //特定值查询
    NSString * sql = [NSString stringWithFormat:@"select * from %@ where %@", tableName, sqlContent];
//    @synchronized(_database) {
        result = [_database executeQuery:sql];
//    }
    NSLog(@"条件查:%@", sql);
    
    NSMutableArray * array = [NSMutableArray array];
    
    while ([result next]) {
        
        NSMutableArray * objcArr = [NSMutableArray array];
        
        for (NSString * key in keyArray) {
            id object = [result objectForColumnName:key];
            [objcArr addObject:object];
        }
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:objcArr forKeys:keyArray];
        
        [array addObject:dict];
    }
    [result close];
    
    [_lock unlock];
    
    return array;
}

#pragma mark -修改单条数据
- (void)updateTable:(NSString *)tableName paraDict:(NSDictionary *)dict newParaDict:(NSDictionary *)dict2
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    [_lock lock];
    
    NSString * key1 = [[dict allKeys] firstObject];
    NSString * key2 = [[dict2 allKeys] firstObject];
    
    NSString * sql = [NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ?", tableName, key2, key1];
    
    BOOL bo = NO;
//    @synchronized(_database) {
        bo = [_database executeUpdate:sql, dict2[key2], dict[key1]];
//    }
    NSLog(@"改:%@%@%@", sql, dict2[key2], dict[key1]);
    
    if (!bo) {
        NSLog(@"修改失败：%@", _database.lastErrorMessage);
    }
    
    [_lock unlock];
}

#pragma mark - 删除指定时间的数据
- (void)deleteDatasFromTable:(NSString *)tableName withTimeIntervalKeyPath:(NSString *)keyPath andTimeAgoInSecond:(NSTimeInterval)second
{
    if (![_database open]) {
        NSLog(@"不能打开数据库");
        return ;
    }
    
    //当前时间
    NSInteger timeNow = [timeIntervalForDB() integerValue];
    
    [_lock lock];
    
    FMResultSet * result = nil;
    
    NSString *sql = [NSString stringWithFormat:@"select %@ from %@", keyPath, tableName];
    
    //查找对应key
//    @synchronized(_database) {
        result = [_database executeQuery:sql];
//    }
    NSLog(@"全查:select %@ from %@", keyPath, tableName);
    
    while ([result next]) {
        
        id object = [result objectForColumnName:keyPath];
        if ((timeNow - [object integerValue])/1000. > second) {
            NSLog(@"===%lf", (timeNow - [object integerValue])/1000.0);
            
            NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?", tableName, keyPath];
            
            BOOL bo = NO;
//            @synchronized(_database) {
                bo = [_database executeUpdate:sql, object];
//            }
            NSLog(@"删:%@%@", sql, object);
            
            if (!bo) {
                NSLog(@"删除失败：%@", _database.lastErrorMessage);
            }
        }
    }
    [result close];
    
    [_lock unlock];
}

#pragma mark - dealloc
- (void)dealloc
{
    @synchronized(self) {
        //关闭数据库
        [_database close];
        _database = nil;
    }
}

@end
