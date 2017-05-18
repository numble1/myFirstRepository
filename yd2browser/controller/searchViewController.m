//
//  searchViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/10.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "searchViewController.h"
#import "customCollectionViewCell.h"
#import "headerView.h"
#import "subTableViewCell.h"
#import "historyViewController.h"
#import "bookMarkViewController.h"
#import "WebViewController.h"

@interface searchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,NSURLConnectionDataDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSArray*arr;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *historyArr;
@property(nonatomic,strong)NSMutableArray *bookArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectViewHeight;

@end

@implementation searchViewController
-(headerView *)headerV{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"headerView" owner:self options:nil];
    headerView *headerV = arr[0];
    return headerV;
}
-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr =  [NSMutableArray array];
    }
    return _historyArr;
}
-(NSMutableArray *)bookArr{
    if (!_bookArr) {
       _bookArr = [NSMutableArray array];
    }return _bookArr;
}
- (IBAction)clear:(id)sender {
    self.clearBtn.hidden = YES;
    self.searchBar.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.text  = self.textFieldStr;
    [self.searchBar becomeFirstResponder];
    self.collectViewHeight.constant = 0;
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.tableFooterView = [UIView new];
    self.clearBtn.hidden = YES;
    self.searchBar.delegate =self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"customCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}
- (void)fetchWith:(NSString *)string{
    NSString*str = [NSString stringWithFormat:@"https://sp0.baidu.com/5a1Fazu8AA54nxGko9WTAnF6hhy/su?wd=%@&sugmode=2&json=1",string];
    NSString*encoderStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encoderStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *string = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        NSLog(@"string ===== %@", string);
        string = [string stringByReplacingOccurrencesOfString:@"window.baidu.sug(" withString:@""];
        string = [string substringToIndex:[string length] - 2];
        NSDictionary *dict = [JSONParse stringToNSDictionary:string];
        self.arr = [JSONParse optNSArray:dict valueForKey:@"s"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.arr.count>0) {
                self.collectViewHeight.constant = 120;
                [self.collectionView reloadData];
            }
            else{
                self.collectViewHeight.constant = 0;
            }
        });
    }];
    [sessionDataTask resume];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)isString:(NSString*)string contain:(NSString*)str{
    if([string rangeOfString:str].location !=NSNotFound)//_roaldSearchText
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *nowStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (nowStr.length>0) {
        self.clearBtn.hidden = NO;
        [self ReloadTableViewWithTextField:nowStr];
    }
    else{
        self.clearBtn.hidden = YES;
    }
    [self fetchWith:nowStr];
    return YES;
}
-(void)ReloadTableViewWithTextField:(NSString *)str{
    NSMutableArray *historyArr = [historyUtil getHistory];
    NSMutableArray *bookMarkArr = [bookMarkUtil getBookMark];
    [self.historyArr removeAllObjects];
    [self.bookArr removeAllObjects];
    for (historyBean* bean in historyArr) {
        if ([self isString:bean.title contain:str]) {
            [self.historyArr addObject:bean];
        }
    }
    for (bookmarkBean* bean in bookMarkArr) {
        if ([self isString:bean.title contain:str]) {
            [self.bookArr addObject:bean];
        }
    }
    [self.tableView reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@",textField.text];
    if (textField.text.length > 4) {
    NSString *str = [textField.text substringToIndex:3];
      if ([str isEqualToString:@"http"]) {
          urlStr = textField.text;
      }
      else{
         urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       }
    }
    else{
         urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        if (self.DpageC){
        [self.DpageC creatWebWith:[NSURL URLWithString:urlStr]];
        }
        else{
            if (self.main) {
                [self.main.delegate creatWebWith:[NSURL URLWithString:urlStr]];
            }
        }
        
    }];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *originCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    customCollectionViewCell*cell = (customCollectionViewCell*)originCell;
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"customCollectionViewCell" owner:self options:nil];
        cell = arr[0];
    }
    if (indexPath.row>self.arr.count-1) {
        cell.label.text = @"";
    }
    else{
        NSString *str = self.arr[indexPath.row];
        cell.label.text = str;
    }
    return  cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //可以用数组收集cell，但此处不需要获取cell，就能得到size
    CGSize size = CGSizeMake(0, 0);
    if (indexPath.row>self.arr.count-1||self.arr.count==0||!self.arr) {
        return size;
    }
    else{
       size = [self.arr[indexPath.row] boundingRectWithSize:CGSizeMake( MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}context:nil].size;
    }
    return CGSizeMake(size.width+10, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    NSString *str = self.arr[indexPath.row];
    self.searchBar.text = str;
    NSString *urlStr = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@",str];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        [self.main.delegate creatWebWith:[NSURL URLWithString:urlStr]];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return  self.historyArr.count;
    }
    else{
        return self.bookArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"subTableViewCell" owner:self options:nil];
    subTableViewCell *cell = arr[0];
    if (indexPath.section==0) {
        if (indexPath.row>self.historyArr.count-1||self.historyArr.count==0||!self.historyArr) {
            cell.label.text = @"";
            cell.detaillabel.text = @"";
        }else{
        historyBean * bean = self.historyArr[indexPath.row];
        cell.label.text = bean.title;
        cell.detaillabel.text = bean.urlStr;
        }
    }
    else{
        if (indexPath.row>self.bookArr.count-1||self.bookArr.count==0||!self.bookArr) {
            cell.label.text = @"";
            cell.detaillabel.text = @"";
        }
        else{
            bookmarkBean *bean = self.bookArr[indexPath.row];
            cell.label.text = bean.title;
            cell.detaillabel.text = bean.urlStr;
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        headerView *view = [self headerV];
        view.text.text = @"相关浏览历史";
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoHistory)]];
        return view;
    }
    else{
        headerView *view = [self headerV];
        view.text.text = @"相关书签";
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoBookMark)]];
        return view;
    }
    return self.headerV;
}
-(void)gotoHistory{
    historyViewController *his = [self.storyboard instantiateViewControllerWithIdentifier:@"historyViewController"];
    his.main = self.main;
    self.title = @"历史记录";
    [self.navigationController pushViewController:his animated:YES];
}
-(void)gotoBookMark{
    bookMarkViewController *bookMark = [self.storyboard instantiateViewControllerWithIdentifier:@"bookMarkViewController"];
    bookMark.main = self.main;
    self.title = @"书签";
    [self.navigationController pushViewController:bookMark animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section==0) {
            historyBean *bean = self.historyArr[indexPath.row];
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                [self.main.delegate creatWebWith:[NSURL URLWithString:bean.urlStr]];
            }];
    }
    else{
            bookmarkBean *bean = self.bookArr[indexPath.row];
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                [self.main.delegate creatWebWith:[NSURL URLWithString:bean.urlStr]];
            }];
    }

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
