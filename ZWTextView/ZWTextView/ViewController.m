//
//  ViewController.m
//  ZWTextView
//
//  Created by zzw on 17/3/13.
//  Copyright © 2017年 Mapgoo. All rights reserved.
//

#import "ViewController.h"
#import "ZWTextView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 400, 200)];
    baseView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:baseView];

    
    ZWTextView *textView = [[ZWTextView alloc] initWithFrame:CGRectMake(50, 50, 100, 100) TextFont:[UIFont systemFontOfSize:14] MoveStyle:styleMove_Center];
    
    textView.placeholder = @"请输入...";
    
    [baseView addSubview:textView];
    
//    MyTextView *textView = [[MyTextView alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
//    textView.placeholder = @"请输入内容.....";
//    textView.delegate = self;
//    textView.bIsFit = YES;
//    textView.maxHeight = 100;
//    [self.view addSubview:textView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
