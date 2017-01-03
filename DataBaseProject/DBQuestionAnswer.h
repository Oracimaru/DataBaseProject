//
//  DBQuestionAnswer.h
//  XESIPS
//
//  Created by JXT on 16/5/9.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "DBManagerBase.h"

@interface DBQuestionAnswer : DBManagerBase

/**
 *  插入一条题目答案缓存
 *
 *  @param levelId     levelId
 *  @param aNowVersion nowVersion
 *  @param studentId   studentId
 *  @param aDic        一道题目的json
 *  @param jsonFileString   一道题目的json下载链接/内容，初始都为链接，内容后续替换更新
 */
+ (void)insertAnswerInDBWithLevelId:(NSString *)levelId questionId:(NSString *)aQuestionId studentId:(NSString *)aStudentId andAnswerDictionary:(NSDictionary *)aDic;

/**
 *  获取该关卡的答案缓存(一条)
 *
 *  @param levelId     levelId
 *  @param aNowVersion nowVersion
 *
 *  @return 缓存的json字典数组
 */
+ (NSArray *)getAnswersInDBWithLevelId:(NSString *)levelId questionId:(NSString *)aQuestionId studentId:(NSString *)aStudentId;


/**
 *  删除该关卡的答案缓存，删除条件对应多条题目，一次性删除
 *
 *  @param levelId     levelId
 *  @param aStudentId  studentId
 */
+ (void)deleteAnswersInDBWithLevelId:(NSString *)levelId studentId:(NSString *)aStudentId;

/**
 *  删除一条缓存
 *
 *  @param levelId     levelId description
 *  @param aQuestionId aQuestionId description
 *  @param aStudentId  aStudentId description
 */
+ (void)deleteAnswerInDBWithLevelId:(NSString *)levelId questionId:(NSString *)aQuestionId studentId:(NSString *)aStudentId;

@end
