//
//  DBManagerBase.h
//  XESIPS
//
//  Created by JXT on 16/5/9.
//  Copyright © 2016年 Danny. All rights reserved.
//

#import "IPSDatabaseManager.h"

//题目表名
#define kQuestionInfoDBTableName @"questionInfoDBTableName"
//题目表中的字段
#define kLevelId          @"levelId"          //关卡id
#define kNowVersion       @"nowVersion"       //题目版本号
#define kStudentId        @"studentId"        //学员id
#define kInsertTime       @"insertTime"       //写入时间戳
#define kQuestionJson     @"questionJson"     //题目一级json
#define kJsonFileUrl      @"jsonFileUrl"      //题目jsonurl
#define kJsonFileDownload @"jsonFileDownload" //题目二级json（根据url下载的json）
#define kAnswerCommitDict @"answerCommitDict" //题目提交的答案json

//答案表名
#define kQuestionAnswerDBTableName @"questionAnswerDBTableName"
//答案表名中的字段
#define kQuestionDBId         @"questionDBId"
#define kQuestionAnswerDBJson @"questionAnswerJson"


//点赞表名
#define kLikeDBTableName      @"likeDBTableName"
//点赞表中的字段
#define kLikeTaskId           @"likeTaskId"          //当前任务ID
#define kLikeCurrentUserId    @"likeCurrentUserId"   //当前用户ID
#define kLikeOtherId          @"likeOtherId"         //被点赞者ID


@interface DBManagerBase : IPSDatabaseManager

/**
 *  数据转换处理
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;


/**
 *  题目建表
 */
+ (void)createQuestionInfoDBTable;
/**
 *  题目删表
 */
+ (void)deleteQuestionInfoDBTable;


/**
 *  答案建表
 */
+ (void)createQuestionAnswerDBTable;
/**
 *  答案删表
 */
+ (void)deleteQuestionAnswerDBTable;


/**
 *  点赞建表
 */
+ (void)createLikeDBTable;
/**
 *  点赞删表
 */
+ (void)deleteLikeDBTable;

@end
