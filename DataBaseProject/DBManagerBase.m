//
//  DBManagerBase.m
//  XESIPS
//
//  Created by JXT on 16/5/9.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "DBManagerBase.h"

@implementation DBManagerBase

#pragma mark - 数据处理
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil || jsonString.length <= 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (jsonData == nil || jsonData.length <= 0) {
        return nil;
    }
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    if (dic.count<=0) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark - 题目建表
+ (void)createQuestionInfoDBTable
{
    NSDictionary * dict = @{
                            kLevelId:@"TEXT",
                            kNowVersion:@"TEXT",
                            kStudentId:@"TEXT",
                            kInsertTime:@"INTEGER",
                            kQuestionJson:@"TEXT",
                            kJsonFileUrl:@"TEXT",
                            kJsonFileDownload:@"TEXT",
                            kAnswerCommitDict:@"TEXT" //没用了，暂时保留
                            };
    [[IPSDatabaseManager sharedDBManager] createTableWithName:kQuestionInfoDBTableName byKeyValueDict:dict];
}

+ (void)deleteQuestionInfoDBTable
{
    [[IPSDatabaseManager sharedDBManager] dropTableWithName:kQuestionInfoDBTableName];
}


#pragma mark - 答案建表
+ (void)createQuestionAnswerDBTable
{
    NSDictionary * dict = @{
                            kLevelId:@"TEXT",
                            kStudentId:@"TEXT",
                            kQuestionDBId:@"TEXT",
                            kInsertTime:@"INTEGER",
                            kQuestionAnswerDBJson:@"TEXT"
                            };
    [[IPSDatabaseManager sharedDBManager] createTableWithName:kQuestionAnswerDBTableName byKeyValueDict:dict];
}

+ (void)deleteQuestionAnswerDBTable
{
    [[IPSDatabaseManager sharedDBManager] dropTableWithName:kQuestionAnswerDBTableName];
}

#pragma mark - 点赞建表
+ (void)createLikeDBTable{
    NSDictionary * dict = @{
                            kLikeTaskId:@"TEXT",
                            kLikeCurrentUserId:@"TEXT",
                            kLikeOtherId:@"TEXT"
                            };
    [[IPSDatabaseManager sharedDBManager] createTableWithName:kLikeDBTableName byKeyValueDict:dict];
    
}
+ (void)deleteLikeDBTable
{
    [[IPSDatabaseManager sharedDBManager] dropTableWithName:kLikeDBTableName];
}

@end
