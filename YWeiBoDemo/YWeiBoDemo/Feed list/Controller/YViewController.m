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
#import "YPhotoBrowser.h"
#import "YPhotoBrowserModel.h"
#import "YWBPhotoView.h"

@interface YViewController ()<UITableViewDelegate,UITableViewDataSource,YWBStatusCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *wbList;

@property (nonatomic, strong) YPhotoBrowser *photoBrowser;

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

#pragma mark - Cell delegate
- (void)cellDidClick:(YWBFeedListCell *)cell {
    NSLog(@"%s cell.status.id:%@",__func__,cell.statusM.idStr);
}

- (void)cellDidClickTag:(YWBFeedListCell *)cell {
    NSLog(@"%s",__func__);
}

- (void)cell:(YWBFeedListCell *)cell didClickUser:(YWBUser *)user {
    NSLog(@"%s cell.user.id:%@",__func__,user.idStr);
}

- (void)cell:(YWBFeedListCell *)cell didClickImageAtIndex:(NSUInteger)index {
    NSLog(@"%s  index:%zi",__func__,index);
    
    YWBPhotoView *fromView = nil;
    NSMutableArray *arr = @[].mutableCopy;
    YWBStatus *status = cell.statusM;
    NSArray<YWBPicInfo *> *pics = status.retweeted_status ? status.retweeted_status.pics : status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        YWBPhotoView *imgView = cell.picViews[i];
        YWBPicInfo *pic = pics[i];
        YWBPicMetadata *meta = pic.largest.badgeType == YWBPicBadgeTypeGIF ? pic.largest : pic.large;
        YPhotoBrowserModel *model = [YPhotoBrowserModel new];
        model.placeholderView = imgView;
        model.imageURL = meta.url;
        model.imageSize = CGSizeMake(meta.width, meta.height);
        [arr addObject:model];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    
    _photoBrowser = [[YPhotoBrowser alloc] init];
    _photoBrowser.currentIndex = index;
    _photoBrowser.imageArr = arr;
    _photoBrowser.fromView = fromView;
    _photoBrowser.picViews = cell.picViews;
    _photoBrowser.toContainerView = self.navigationController.view;
    
    [self presentViewController:_photoBrowser animated:YES completion:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
