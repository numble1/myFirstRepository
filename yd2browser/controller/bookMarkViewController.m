//
//  bookMarkViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/12.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "bookMarkViewController.h"
#import "subTableViewCell.h"

@interface bookMarkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic ,strong)NSArray *arr;

@end

@implementation bookMarkViewController
-(NSArray *)arr{
    if (!_arr){
        _arr = [bookMarkUtil getBookMark];
    }
    return _arr;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"subTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    subTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"subTableViewCell" owner:self options:nil];
        cell = arr[0];
    }
    bookmarkBean * bean = self.arr[indexPath.row];
    cell.label.text = bean.title;
    cell.detaillabel.text = bean.urlStr;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    bookmarkBean *bean = self.arr[indexPath.row];
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        [self.main.delegate creatWebWith:[NSURL URLWithString:bean.urlStr]];
    }];
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
