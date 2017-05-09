//
//  RingListViewController.m
//  yd2ringtone
//
//  Created by yunfenghan Ling on 3/3/17.
//  Copyright © 2017 lingyfh. All rights reserved.
//

#import "ListViewController.h"
#import "TableViewCell.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    // 请求数据
    [self requestDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - table delegate

#pragma mark - table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.ringTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}


#pragma mark - request

- (HTTPMethod)requestMethod {
    return GET;
}

- (NSString *)createRequestURL {
    [super createRequestURL];
    return @"http://www.toutiao.com/api/pc/focus/";
}

- (NSMutableDictionary *)createParams {
    NSMutableDictionary *params = [super createParams];
    [params setValue:@"0" forKey:PARAM_SKIP];
    [params setValue:@"50" forKey:PARAM_LIMIT];
    return params;
}

- (void)requestSuccess:(NSDictionary *)dict {
    [super requestSuccess:dict];
    NSDictionary *data = [JSONParse optNSDictionary:dict valueForKey:@"data"];
    NSDictionary *pc_feed_focus = [JSONParse optNSDictionary:data valueForKey:@"pc_feed_focus"];
    NSLog(@"request success dict = %@", dict);
    NSLog(@"request success data = %@", data);
    NSLog(@"request success pc_feed_focus = %@", pc_feed_focus);
}

- (void)requestFinish {
    [super requestFinish];
    [self.view makeToast:@"网络请求成功"];
    NSLog(@"request finish");
}

- (void)requestFailure:(NSError *)error {
    [super requestFailure:error];
    NSLog(@"request failure error = %@", error);
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
