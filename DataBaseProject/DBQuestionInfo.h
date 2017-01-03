//
//  DBQuestionInfo.h
//  XESIPS
//
//  Created by JXT on 16/4/29.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "DBManagerBase.h"

@interface DBQuestionInfo : DBManagerBase
/**
 *  插入一条题目缓存
 *
 *  @param levelId     levelId
 *  @param aNowVersion nowVersion
 *  @param studentId   studentId
 *  @param aDic        一道题目的json
 *  @param jsonFileString   一道题目的json下载链接/内容，初始都为链接，内容后续替换更新
 */
+ (void)insertQuestionInDBWithLevelId:(NSString *)levelId nowVersion:(NSString *)aNowVersion studentId:(NSString *)aStudentId andDictionary:(NSDictionary *)aDic andJsonFileString:(NSString *)jsonFileString;
/**
 *  获取该关卡所有的题目缓存
 *
 *  @param levelId     levelId
 *  @param aNowVersion nowVersion
 *
 *  @return 缓存的json字典数组
 */
+ (NSArray *)getQuestionsInDBWithLevelId:(NSString *)levelId nowVersion:(NSString *)aNowVersion studentId:(NSString *)aStudentId;


/**
 *  更新下载的题目json文件
 *
 *  @param fileUrl    原来存储的json文件的url
 *  @param fileString 下载后的json文件字符串
 */
+ (void)updateJsonFileStringWithFileUrl:(NSString *)fileUrl andDownloadFileString:(NSString *)fileString;
/**
 *  更具题目url获取对应的存储的file字典
 *
 *  @param fileUrl fileUrl
 *
 *  @return file字典
 */
+ (NSDictionary *)getDownloadQuestionsJsonFileInDBWithFileUrl:(NSString *)fileUrl;

/**
 *  删除该关卡的题目缓存，删除条件对应多条题目，一次性删除，不匹配关卡version是因为version可能已经改变
 *
 *  @param levelId     levelId
 *  @param aStudentId  studentId
 */
+ (void)deleteQuestionInDBWithLevelId:(NSString *)levelId studentId:(NSString *)aStudentId;
/**
 *  删除指定时间期限的数据
 *
 *  @param second 时间间隔，秒
 */
+ (void)deleteDatasTimeAgoInSecond:(NSTimeInterval)second;

@end
