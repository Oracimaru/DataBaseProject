//
//  DBQuestionAnswer.m
//  XESIPS
//
//  Created by JXT on 16/5/9.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "DBQuestionAnswer.h"

@implementation DBQuestionAnswer

+ (void)insertAnswerInDBWithLevelId:(NSString *)levelId questionId:(NSString *)aQuestionId studentId:(NSString *)aStudentId andAnswerDictionary:(NSDictionary *)aDic
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aQuestionId] || [NSString isBlankString:aStudentId] || [NSObject empty:aDic]) {
        return ;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kQuestionDBId:aQuestionId,
                            kStudentId:aStudentId,
                            kInsertTime:timeIntervalForDB(),
                            kQuestionAnswerDBJson:[self dictionaryToJson:aDic],
                            };
    [[IPSDatabaseManager sharedDBManager] insertDataToTable:kQuestionAnswerDBTableName byKeyValueDict:dict];
}

+ (NSArray *)getAnswersInDBWithLevelId:(NSString *)levelId questionId:(NSString *)aQuestionId studentId:(NSString *)aStudentId
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aQuestionId] || [NSString isBlankString:aStudentId]) {
        return nil;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kQuestionDBId:aQuestionId,
                            kStudentId:aStudentId
                            };
    NSArray * dataArr = [[IPSDatabaseManager sharedDBManager] selectDatasFromTable:kQuestionAnswerDBTableName byKeyValueDict:dict andCollectByKeys:@[kQuestionAnswerDBJson]];
    DLog(@"%@", dataArr);
    //二进制数组
    NSMutableArray * jsonDictArray = [NSMutableArray arrayWithCapacity:dataArr.count];
    
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary * tmpDict = [self dictionaryWithJsonString:[dataArr[i] objectForKey:kQuestionAnswerDBJson]];
        [jsonDictArray addObject:tmpDict];
        DLog(@"答案-数据库缓存：%@", tmpDict);
    }
    //字典数组
    return jsonDictArray;
}

+ (void)deleteAnswersInDBWithLevelId:(NSString *)levelId studentId:(NSString *)aStudentId
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aStudentId]) {
        return ;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kStudentId:aStudentId
                            };
    [[IPSDatabaseManager sharedDBManager] deleteDataFromTable:kQuestionAnswerDBTableName byKeyValueDict:dict];
}

+ (void)deleteAnswerInDBWithLevelId:(NSString *)levelId questionId:(NSString *)aQuestionId studentId:(NSString *)aStudentId
{
    if ([NSString isBlankString:levelId] || [NSString isBlankString:aQuestionId] || [NSString isBlankString:aStudentId]) {
        return ;
    }
    NSDictionary * dict = @{
                            kLevelId:levelId,
                            kQuestionDBId:aQuestionId,
                            kStudentId:aStudentId
                            };
    [[IPSDatabaseManager sharedDBManager] deleteDataFromTable:kQuestionAnswerDBTableName byKeyValueDict:dict];
}

@end
