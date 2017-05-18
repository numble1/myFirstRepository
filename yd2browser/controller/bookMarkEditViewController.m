//
//  bookMarkViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/12.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "bookMarkEditViewController.h"
#import "subTableViewCell.h"

@interface bookMarkEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic ,strong)NSArray *arr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonHeight;
@property(nonatomic,strong)UIBarButtonItem *rightItem;
@end

@implementation bookMarkEditViewController
-(UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
       
    }return _rightItem;
}
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
- (IBAction)delete:(id)sender{
    NSString *message = nil;
    if (self.tableView.indexPathsForSelectedRows.count==0) {
        message = @"未选中任何书签";
    }
    else{
        message = @"确认删除选中的书签";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [bookMarkUtil removewMarkBeanWith:self.tableView.indexPathsForSelectedRows];
        self.arr = nil;
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)seletctAll:(id)sender {
    for (int i = 0;i<self.arr.count; i++){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)edit{
    if(self.tableView.editing){
         [self.tableView setEditing:NO];
         self.rightItem.title = @"编辑";
        self.bottonHeight.constant = 0;
    }
    else{
        [self.tableView setEditing:YES];
        self.rightItem.title = @"取消";
        self.bottonHeight.constant = 50;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.bottonHeight.constant = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"subTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle==UITableViewCellEditingStyleDelete) {
//        //如果用户提交的是删除操作，下方代码执行顺序严格要求
//        
//    }
//
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
