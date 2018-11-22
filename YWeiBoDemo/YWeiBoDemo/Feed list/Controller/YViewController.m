//
//  ViewController.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/21.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YViewController.h"
#import "YWBModel.h"

@interface YViewController ()

@end

@implementation YViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"微博 Demo";
    NSData *data = [NSData dataNamed:@"weibo_0.json"];
    YWBModel *wbModel = [YWBModel modelWithJSON:data];
    DDLogInfo(@"wbModel %@",wbModel);
    
}


@end
