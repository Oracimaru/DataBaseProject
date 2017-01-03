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
    [DBQuestionInfo insertQuestionInDBWithLevelId:@"4" nowVersion:@"3.1.2" studentId:@"2" andDictionary:@{@"name":@"zhangsan",@"age":@"21"} andJsonFileString:@"api.kaojibang.com"];
    
    [DBQuestionInfo getQuestionsInDBWithLevelId:@"1" nowVersion:@"3.1.2" studentId:@"2"];
    
    NSString * responString = @"{\"errcode\":0,\"errmsg\":\"\",\"version\":\"1.0\",\"res\":{\"total\":1,\"list\":[{\"id\":\"47\",\"teacher\":\"\u53f6\u857e,\u949f\u5e73\"}],\"advert\":[]},\"state\":1}";
    [DBQuestionInfo updateJsonFileStringWithFileUrl:@"api.kaojibang.com" andDownloadFileString:[DBQuestionInfo dictionaryToJson:@{@"responString":responString}]];
    
    [DBQuestionInfo getDownloadQuestionsJsonFileInDBWithFileUrl:@"api.kaojibang.com"];
    
    
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
