//
//  ViewController.m
//  DataBaseProject
//
//  Created by emuch on 2016/12/30.
//  Copyright © 2016年 100TALDT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
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
