//
//  ViewController.m
//  DataBaseProject
//
//  Created by emuch on 2016/12/30.
//  Copyright © 2016年 100TALDT. All rights reserved.
//

#import "ViewController.h"
#import "DBQuestionInfo.h"
#import "DatabaseManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
    [DatabaseManager sharedDBManager];
    /*
     kQuestionJson:,@{@"name":@"zhangsan",@"age":@"21"}
     kJsonFileUrl:@"hello",
     kJsonFileDownload:@"hello",
     kAnswerCommitDict:@"hello"
     };
     */
    [DBQuestionInfo insertQuestionInDBWithLevelId:@"1" nowVersion:@"21" studentId:@"zhang" andDictionary:@{@"name":@"zhangsan",@"age":@"21"} andJsonFileString:@"hello"];
    
    [DBQuestionInfo getQuestionsInDBWithLevelId:@"1" nowVersion:@"21" studentId:@"zhang"];
    
    [DBQuestionInfo updateJsonFileStringWithFileUrl:@"hello" andDownloadFileString:[DBQuestionInfo dictionaryToJson:@{@"responString":@"khffklall"}]];
    
    [DBQuestionInfo getDownloadQuestionsJsonFileInDBWithFileUrl:@"hello"];
    
    
    [DBQuestionInfo deleteDatasTimeAgoInSecond:10];
}
- (void)setUI
{
    self.view.backgroundColor = [UIColor purpleColor];
    self.title = @"dataBaseController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
