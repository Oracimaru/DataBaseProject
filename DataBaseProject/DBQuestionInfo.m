//
//  DBQuestionInfo.m
//  XESIPS
//
//  Created by JXT on 16/4/29.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "DBQuestionInfo.h"

@implementation DBQuestionInfo

#pragma mark - 缓存一道题目
+ (void)insertQuestionInDBWithLevelId:(NSString *)levelId nowVersion:(NSString *)aNowVersion studentId:(NSString *)aStudentId andDictionary:(NSDictionary *)aDic andJsonFileString:(NSString *)jsonFileString
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aNowVersion] || [NSString isBlankString:aStudentId] || [NSString isBlankString:jsonFileString] || [NSObject empty:aDic]) {
        return ;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kNowVersion:aNowVersion,
                            kStudentId:aStudentId,
                            kInsertTime:timeIntervalForDB(),
                            kQuestionJson:[self dictionaryToJson:aDic],
                            kJsonFileUrl:jsonFileString,
                            kJsonFileDownload:jsonFileString,
                            kAnswerCommitDict:jsonFileString //初始用url占位
                            };
    [[DatabaseManager sharedDBManager] insertDataToTable:kQuestionInfoDBTableName byKeyValueDict:dict];
}

#pragma mark -获取缓存题目json数组（元素为字典）
+ (NSArray *)getQuestionsInDBWithLevelId:(NSString *)levelId nowVersion:(NSString *)aNowVersion studentId:(NSString *)aStudentId
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aNowVersion] || [NSString isBlankString:aStudentId]) {
        return nil;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kNowVersion:aNowVersion,
                            kStudentId:aStudentId
                            };
    NSArray * dataArr = [[DatabaseManager sharedDBManager] selectDatasFromTable:kQuestionInfoDBTableName byKeyValueDict:dict andCollectByKeys:@[kQuestionJson]];
    NSLog(@"%@", dataArr);
    //二进制数组
    NSMutableArray * jsonDictArray = [NSMutableArray arrayWithCapacity:dataArr.count];
    
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary * tmpDict = [self dictionaryWithJsonString:[dataArr[i] objectForKey:kQuestionJson]];
        [jsonDictArray addObject:tmpDict];
        NSLog(@"题目-数据库缓存：%@", tmpDict);
    }
    //字典数组
    return jsonDictArray;
}

#pragma mark - 更新下载的json文件字符串
+ (void)updateJsonFileStringWithFileUrl:(NSString *)fileUrl andDownloadFileString:(NSString *)fileString
{
    if ([NSString isBlankString:fileUrl] || [NSString isBlankString:fileString]) {
        return ;
    }
    [[DatabaseManager sharedDBManager] updateTable:kQuestionInfoDBTableName paraDict:@{kJsonFileDownload:fileUrl} newParaDict:@{kJsonFileDownload:fileString}];
}

#pragma mark -获取缓存题目jsonfile字典
+ (NSDictionary *)getDownloadQuestionsJsonFileInDBWithFileUrl:(NSString *)fileUrl
{
    if ([NSString isBlankString:fileUrl]) {
        return nil;
    }

    NSArray * dataArr = [[DatabaseManager sharedDBManager] selectDatasFromTable:kQuestionInfoDBTableName byParaName:kJsonFileUrl paraValue:fileUrl andCollectByKeys:@[kJsonFileDownload]];
    
    //如果对应的内容没有被下载的数据替换，则返回空
    if ([[[dataArr firstObject] objectForKey:kJsonFileDownload] isEqualToString:fileUrl]) {
        return nil;
    }

    NSDictionary * tmpDict = [self dictionaryWithJsonString:[[dataArr firstObject] objectForKey:kJsonFileDownload]]; //应该只有一条数据
    NSLog(@"题目-数据库缓存：%@", tmpDict);
    //字典数组
    return tmpDict;
}

#pragma mark - 删除相关缓存，因为条件不唯一，可以一次性删除
+ (void)deleteQuestionInDBWithLevelId:(NSString *)levelId studentId:(NSString *)aStudentId
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aStudentId]) {
        return ;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kStudentId:aStudentId
                            };
    [[DatabaseManager sharedDBManager] deleteDataFromTable:kQuestionInfoDBTableName byKeyValueDict:dict];
}

#pragma mark -删除指定时间的数据
+ (void)deleteDatasTimeAgoInSecond:(NSTimeInterval)second
{
    [[DatabaseManager sharedDBManager] deleteDatasFromTable:kQuestionInfoDBTableName withTimeIntervalKeyPath:kInsertTime andTimeAgoInSecond:second];
}

@end
