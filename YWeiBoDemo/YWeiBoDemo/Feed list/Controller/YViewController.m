//
//  ViewController.m
//  YWeiBoDemo
//
//  Created by YXW on 2018/11/21.
//  Copyright © 2018 YXW. All rights reserved.
//

#import "YViewController.h"
#import "YWBModel.h"
#import "YWBFeedListCell.h"

@interface YViewController ()<UITableViewDelegate,UITableViewDataSource,YWBStatusCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *wbList;


@end

@implementation YViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWBCellBackgroundColor;
    self.navigationItem.title = @"微博 Demo";
    
    [self setupTableView];
    _wbList = @[].mutableCopy;
    kWeakSelf(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i <= 7; i++) {
            NSData *data = [NSData dataNamed:kNSStringFormat(@"weibo_%zi.json",i)];
            YWBModel *wbModel = [YWBModel modelWithJSON:data];
//            DDLogInfo(@"wbModel %@",wbModel);
            for (YWBStatus *status in wbModel.statuses) {

                [status y_layout];
                [weakself.wbList addObject:status];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    });
   
}

- (void)setupTableView {
    _tableView = [UITableView new];
    _tableView.top = 0;//kTopHeight;
    _tableView.width = kScreenWidth;
    _tableView.height = kScreenHeight -kTopHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delaysContentTouches = NO;
    
    _tableView.canCancelContentTouches = YES;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[YWBFeedListCell class] forCellReuseIdentifier:[YWBFeedListCell className]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _wbList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DDLogInfo(@"row: %zi cellHeight:%.f",indexPath.row,((YWBStatus *)_wbList[indexPath.row]).cellHeight);
    return ((YWBStatus *)_wbList[indexPath.row]).cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWBFeedListCell *cell = [tableView dequeueReusableCellWithIdentifier:[YWBFeedListCell className] forIndexPath:indexPath];
    cell.statusM = _wbList[indexPath.row];
    cell.delegate = self;
    return cell;
}

@end
