//
//  mainViewController.m
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "MainViewController.h"
#import "NTButton.h"
#import "UIImage+scale.h"
#import "ViewController.h"
#import "newsTableViewCell.h"
#import "NewsBean.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DpageViewController.h"


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIWebViewDelegate,webDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSMutableArray *urlArr;
@property(nonatomic,unsafe_unretained)NSInteger currentPage;
@property(nonatomic,strong)UIView *categotaryView;
@end

@implementation MainViewController
-(UIView *)categotaryView{
    if (!_categotaryView) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"categatoryView" owner:self options:nil];
        _categotaryView = arr[0];
    }return _categotaryView;
}
-(NSMutableArray *)urlArr{
    if (!_urlArr) {
        _urlArr = [NSMutableArray array];
    }return _urlArr;
}
-(UIWebView *)webView{
    if (!_webView){
        _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _currentPage = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRefresh) name:@"endRefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView) name:@"reloadView" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // _currentIndexBtn.titleLabel.text = @"1";
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
        [self upDateView];
        [self reloadTableView];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
        [self loadMore];
    }];
    for (int i = 0; i<10; i++) {
        [self creatButtonWithNormalName:@"星" andTitle:@"测试" andIndex:i];
    }
    [self reloadTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"newsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"news"];
}
-(void)reloadView{
    [self.categotaryView removeFromSuperview];
    self.headerViewHeight.constant = 260;
    self.headerView.hidden = NO;
}
-(void)endRefresh{
    [self.tableView reloadData];
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}
-(void)upDateView{
    self.headerViewHeight.constant = 50;
    self.headerView.hidden = YES;
    self.categotaryView.frame = CGRectMake(0, 0,620,40);
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    scrollV.contentSize = CGSizeMake(620, 0);
    [scrollV addSubview:self.categotaryView];
    [self.mainView addSubview:scrollV];
}
- (void)creatButtonWithNormalName:(NSString *)normal andTitle:(NSString *)title andIndex:(int)index{
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.tag = index;
    CGFloat buttonW = [UIScreen mainScreen].bounds.size.width/5;
    CGFloat buttonH = self.topView.frame.size.height/2;
    customButton.frame = CGRectMake(buttonW * (index%5),buttonH*(index/5), buttonW, buttonH);
    [customButton setImage:[[UIImage imageNamed:normal] scaleToSize:CGSizeMake(22, 22)] forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //这里应该设置选中状态的图片。wsq
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    customButton.imageView.contentMode = UIViewContentModeCenter;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:customButton];
}
-(void)click:(NTButton*)sender{
    [self.delegate show];
#pragma mark 动态修改
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    
}- (void)webViewDidFinishLoad:(UIWebView *)webView{
    for (NSURL * url in self.urlArr) {
        if ([url isEqual:webView.request.URL]) {
            return;
        }
    }
    if (!webView.isLoading) {
        NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        NSString* str = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('adpic')[0].style.display = 'none'"];
        NSLog(@"打印%@",str);
        BOOL complete = [readyState isEqualToString:@"complete"];
        if (complete) {
            if (_currentPage+1>=self.urlArr.count){
                _currentPage++;
                [self.urlArr addObject:webView.request.URL];
                NSLog(@"数组%@",self.urlArr);
            }
            else{
                _currentPage++;
                [self.urlArr insertObject:webView.request.URL atIndex:_currentPage];
                NSLog(@"数组%@",self.urlArr);
                NSLog(@"currentPage:%ld,count:%ld",_currentPage,_urlArr.count);
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"false"}];
        }
    }
    if (webView.canGoBack&&webView.canGoForward) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"true"}];
    }
    else if(webView.canGoBack&&!webView.canGoForward){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"false"}];
    }
    else if (!webView.canGoBack&&webView.canGoForward){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"false",@"forward":@"true"}];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"false",@"forward":@"false"}];
    }
}
-(void)back{
    if (_currentPage==1) {
        [self.webView removeFromSuperview];
        _webView = nil;
        return;
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"true"}];
    }
    _currentPage--;
    [self.webView goBack];
    
}
-(void)forward{
    if (_currentPage==self.urlArr.count-2) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"forward":@"false",@"back":@"true"}];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"forward":@"true",@"back":@"true"}];
    }
    _currentPage++;
    [self.webView goForward];
    
}
-(void)main{
    [self.urlArr removeAllObjects];
    [self.webView removeFromSuperview];
    [self.delegate hide];
    _webView = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"false",@"forward":@"false"}];
    [self reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.beanArr.count == 0||!self.beanArr) {
        return 0;
    }
    return self.beanArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    newsTableViewCell*cell = [self.tableView dequeueReusableCellWithIdentifier:@"news"];
    if (!cell){
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"newsTableViewCell" owner:self options:nil];
        cell = arr[0];
    }
    NewsBean *bean = nil;
    if (self.beanArr.count==0||!self.beanArr){
        
    }else{
        bean = self.beanArr[indexPath.row];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:bean.icon]];
    cell.time.text = bean.time;
    cell.type.text = bean.src;
    cell.title.text = bean.name;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}
-(void)reloadTableView{
    [super reloadTableView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->y > 6) {
        [self upDateView];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"endEdit" object:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate show];
    NewsBean*bean  = self.beanArr[indexPath.row];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:bean.detail_link]]];
    //   NSInteger index = self.currentIndexBtn.titleLabel.text.integerValue;
    //    self.currentIndexBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",index+1];
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
