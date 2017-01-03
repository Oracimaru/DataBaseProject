//
//  DBManagerBase.m
//  XESIPS
//
//  Created by JXT on 16/5/9.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "DBManagerBase.h"

@implementation DBManagerBase
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
    if ([NSObject empty:dic]) {
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
                            kAnswerCommitDict:@"TEXT"
                            };
    [[DatabaseManager sharedDBManager] createTableWithName:kQuestionInfoDBTableName byKeyValueDict:dict];
}

+ (void)deleteQuestionInfoDBTable
{
    [[DatabaseManager sharedDBManager] dropTableWithName:kQuestionInfoDBTableName];
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
    [[DatabaseManager sharedDBManager] createTableWithName:kQuestionAnswerDBTableName byKeyValueDict:dict];
}

+ (void)deleteQuestionAnswerDBTable
{
    [[DatabaseManager sharedDBManager] dropTableWithName:kQuestionAnswerDBTableName];
}

@end
