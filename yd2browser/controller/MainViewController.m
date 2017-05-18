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
#import "customSearchBar.h"
#import "categoryBtn.h"
#import "searchViewController.h"
#import "UIImage+scale.h"
#import "pictureCellTableViewCell.h"
#define NEWS @"news"
#define PICTURECELL @"pictureCell"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,categoryDelegate,UITextFieldDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *tablepageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,strong)NSMutableArray *urlArr;
@property (weak, nonatomic) IBOutlet UIView *customSearchBar;
@property(nonatomic,unsafe_unretained)NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,strong)UIView *smallViewHeaderView;
@property(nonatomic,strong)NSMutableArray *beanArr;
@property(nonatomic,unsafe_unretained)NSInteger pageNow;
@property(nonatomic,strong)UIView *categoryView;
@property(nonatomic,unsafe_unretained)BOOL isHeaderViewHide;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIPageViewController *pageController;
@property(nonatomic,strong)NSMutableArray *tableViewControllers;
@end


@implementation MainViewController
-(NSArray *)tableViewControllers{
    if (!_tableViewControllers) {
        _tableViewControllers = [NSMutableArray array];
        NSArray *arr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"category"];
        for (int i = 0;i<arr.count;i++) {
            UITableViewController *tableC = [[UITableViewController alloc]init];
            [_tableViewControllers addObject:tableC];
        }
    }return _tableViewControllers;
}
//保证app第一次运行时不会调用此方法，否则会报空数据出错
- (UIPageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.delegate = self;
        _pageController.view.frame = CGRectMake(0, 0, self.tablepageView.frame.size.width, self.tablepageView.frame.size.height);
        [self.tablepageView addSubview:_pageController.view];
        for (UIView *subview in _pageController.view.subviews) {
            [(UIScrollView *)subview setDelegate:self];
            //设置是否支持手势滑动
            // [(UIScrollView *)subview setScrollEnabled:NO];
        }
        [_pageController setViewControllers:@[self.tableViewControllers[self.tableViewControllers.count-1]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    return _pageController;
}
-(UITableView *)tableView{
    if (!_tableView) {
        UITableViewController *tableViewC = self.pageController.viewControllers[0];
        _tableView = tableViewC.tableView;
        //_tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tablepageView.frame.size.height);
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"newsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NEWS];
        [_tableView registerNib:[UINib nibWithNibName:@"pictureCellTableViewCell" bundle:nil] forCellReuseIdentifier:PICTURECELL];
         _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
            //  [self upDateView];
            [self reloadTableView];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
            [self loadMore];
        }];
        //[self.tablepageView addSubview:_tableView];
    }return _tableView;
}
//-(void)setPageScrollEnble:(BOOL)yes{
//    for (UIView *subview in self.pageController.view.subviews) {
//        [(UIScrollView *)subview setDelegate:self];
//        //设置是否支持手势滑动
//        [(UIScrollView *)subview setScrollEnabled:yes];
//    }
//}
-(UIView *)smallViewHeaderView{
    if (!_smallViewHeaderView) {
        _smallViewHeaderView = [UIView new];
        _smallViewHeaderView.frame = CGRectMake(0, 22, SCREEN_WIDTH, 80);
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"customSearchBar" owner:self options:nil];
        customSearchBar *bar = arr[0];
        [bar.textField setValue:[UIColor colorWithHexString:@"999999"]forKeyPath:@"_placeholderLabel.textColor"];
        bar.textField.delegate = self;
        bar.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 40);
        self.view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, 40)];
        scrollV.contentSize = CGSizeMake(self.categoryView.frame.size.width, 0);
        scrollV.bounces = NO;
        [scrollV addSubview:self.categoryView];
        scrollV.delegate = self;
        scrollV.tag = 1001;
        [_smallViewHeaderView addSubview:scrollV];
        [_smallViewHeaderView addSubview:bar];
        [self.mainView addSubview:_smallViewHeaderView];
        _smallViewHeaderView.alpha = 0;
    }return _smallViewHeaderView;
}
//动态返回view
-(UIView *)categoryView{
    if (!_categoryView) {
        NSArray *arr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"category"];
        //设分类条高度30 按钮高度20 相距30
        _categoryView  = [UIView new];
        _categoryView.frame = CGRectMake(0, 0, 60*arr.count+30, 40);
        for (NSInteger i = 0;i <arr.count;i++){
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"categoryBtn" owner:self options:nil];
            categoryBtn *btn = array[0];
            NSDictionary *dic = arr[i];
            btn.tittle.text = [dic objectForKey:@"name"];
            btn.frame = CGRectMake(60*i+30, 5, 30, 30);
            btn.delegate = self;
            btn.tag = i+1;
            [self.categoryView addSubview:btn];
        }
        self.categoryView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        return self.categoryView;
    }return _categoryView;
}
-(NSMutableArray *)beanArr{
    if (!_beanArr) {
        _beanArr = [NSMutableArray array];
    }
    return _beanArr;
}

-(NSMutableArray *)urlArr{
    if (!_urlArr) {
        _urlArr = [NSMutableArray array];
    }return _urlArr;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField endEditing:YES];
    searchViewController *searchC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    searchC.main = self;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController: searchC];
    [self presentViewController:navi animated:NO completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)changColorAndfont{
    [_textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.customSearchBar.layer.cornerRadius = 5;
    self.customSearchBar.layer.masksToBounds = YES;
}
- (void)viewDidLoad{
    [super viewDidLoad];
  //  self.pageController.dataSource = nil;
    [self.mainView bringSubviewToFront:self.headerView];
    self.textField.delegate = self;
    [self requestDatas];
    self.pageNow = 0;
    //self.mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self changColorAndfont];
    self.customSearchBar.layer.cornerRadius = 5;
    self.customSearchBar.layer.masksToBounds = YES;
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _currentPage = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRefresh) name:@"endRefresh" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView) name:@"reloadView" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // _currentIndexBtn.titleLabel.text = @"1";
    NSDictionary *dic = [TLRemoteConfig dictionaryForKey:@"homePageWebsites"];
    NSArray *arr = [dic allValues];
    if (arr.count == 0||!arr) {
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createBtn) name:@"createBtn" object:nil];
        for(UIView *vi in self.topView.subviews)
        {
            [vi removeFromSuperview];
        }
        for (int i = 0; i<10; i++) {
            [self creatButtonWithIndex:i];
        }
    }
    else{
        [self createBtn];
        }
    [self reloadTableView];
}
-(void)createBtn{
    for(UIView *vi in self.topView.subviews)
    {
        [vi removeFromSuperview];
    }
    for (int i = 0; i<10; i++) {
    NSDictionary *dic = [TLRemoteConfig dictionaryForKey:@"homePageWebsites"];
    NSArray *arr = [dic allValues];
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.cornerRadius = 5;
    customButton.clipsToBounds = YES;
    customButton.tag = i;
    CGFloat buttonW = [UIScreen mainScreen].bounds.size.width/5;
    CGFloat buttonH = self.topView.frame.size.height/2;
    NSArray *imaTitttleArr = nil;
    imaTitttleArr = arr[i];
    customButton.frame = CGRectMake(buttonW * (i%5),buttonH*(i/5), buttonW, buttonH);
    [customButton setImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imaTitttleArr[1]]]] scaleToSize:CGSizeMake(22, 22)] forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //这里应该设置选中状态的图片。wsq
    
    [customButton setTitle:imaTitttleArr[0] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    customButton.imageView.contentMode = UIViewContentModeCenter;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:customButton];
    }
}
-(void)loadMore{
    self.pageNow = self.pageNow+10;
    [self requestDatas];
}
-(void)endRefresh{
    [self.tableView reloadData];
    if (self.tableView.mj_header.isRefreshing){
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}
-(void)reloadView{
    [self.smallViewHeaderView removeFromSuperview];
    self.smallViewHeaderView = nil;
    self.isHeaderViewHide = NO;
    self.headerView.alpha = 1;
    self.customSearchBar.alpha = 1;
    self.headerView.transform = CGAffineTransformMakeScale(1,1);
    self.headerViewHeight.constant = 300;
    self.headerView.hidden = NO;
    [self.mainView layoutIfNeeded];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated:NO];
    [self.mainView  bringSubviewToFront:self.headerView];
    self.pageController.dataSource = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self.delegate isKindOfClass:[DpageViewController class]]) {
        DpageViewController*pageCtrl = (DpageViewController*)self.delegate;
        if (pageCtrl.viewControllers.count>2) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"false",@"forward":@"true"}];
        }
        else{
             [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"false",@"forward":@"false"}];
        }
    }
}
-(void)upDateView{
    [UIView animateWithDuration:0.5 animations:^{
        _headerViewHeight.constant = 102;
        _headerView.hidden = YES;
        [self.mainView layoutIfNeeded];
        self.smallViewHeaderView.alpha = 1;
    }];
     self.isHeaderViewHide = YES;
    //设置能否滚动
    self.pageController.dataSource = self;
    [self category:1];
}

- (void)creatButtonWithIndex:(int)index{
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.cornerRadius = 5;
    customButton.clipsToBounds = YES;
    customButton.tag = index;
    CGFloat buttonW = [UIScreen mainScreen].bounds.size.width/5;
    CGFloat buttonH = self.topView.frame.size.height/2;
    customButton.frame = CGRectMake(buttonW * (index%5),buttonH*(index/5), buttonW, buttonH);
    [customButton setImage:[[UIImage imageNamed:@"yushecai"] scaleToSize:CGSizeMake(22, 22)] forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //这里应该设置选中状态的图片。wsq
   
    [customButton setTitle:@"..." forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    customButton.imageView.contentMode = UIViewContentModeCenter;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:customButton];
}

-(void)click:(NTButton*)sender{
    NSDictionary *dic = [TLRemoteConfig dictionaryForKey:@"homePageWebsites"];
    NSArray *arr = [dic allKeys];
#pragma mark 动态修改
    [self.delegate creatWebWith:[NSURL URLWithString:arr[sender.tag]]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.beanArr.count == 0||!self.beanArr) {
        //安全保护 防止数据没获取到
        return 10;
    }
    return self.beanArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    newsTableViewCell*cell = [self.tableView dequeueReusableCellWithIdentifier:NEWS];
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
    if (indexPath.row%5==0) {
        pictureCellTableViewCell *pictureCell = [self.tableView dequeueReusableCellWithIdentifier:PICTURECELL];
        if (!pictureCell){
            NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"pictureCellTableViewCell" owner:self options:nil];
            pictureCell = arr[0];
        }
        pictureCell.label.text = bean.name;
        for (UIView *vi in pictureCell.pictureView.subviews) {
            [vi removeFromSuperview];
        }
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(3, 0, pictureCell.pictureView.frame.size.width-5, pictureCell.pictureView.frame.size.height)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:bean.icon]];
        [pictureCell.pictureView addSubview:imageV];
        return pictureCell;
    }
    if (self.beanArr.count == 0||!self.beanArr) {
        //安全保护 防止数据没获取到
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%5==0) {
        return 160;
    }
    return 108;
}
-(void)reloadTableView{
    self.pageNow = 0;
    [self.beanArr removeAllObjects];
    [self requestDatas];
}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//    if (targetContentOffset->y > 6) {
//        [self upDateView];
//    }
//    
//    [self .view endEditing:YES];
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self .view endEditing:YES];
    if (self.isHeaderViewHide) {
        //头部视图如果是分类视图无视滚动
        return;
    }
    else{
        //头部视图是链接进行动画
        float offsetY = scrollView.contentOffset.y;
        if (offsetY>0&&offsetY<198) {
            //动画
            float progress = 1-offsetY/198;
            self.smallViewHeaderView.alpha = offsetY/198;//头部分类视图逐渐呈现出来
            self.headerView.transform = CGAffineTransformMakeScale(1,progress);//原头部视图逐渐消失
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerView.frame.size.height);
            self.headerView.alpha = progress;
            if (self.customSearchBar.frame.origin.y>=22) {
                self.customSearchBar.alpha = 0;
            }
            self.tablepageView.frame = CGRectMake(0, 300-offsetY, SCREEN_WIDTH, SCREEN_HEIGHT-300+offsetY);
            //tableView短一截 给他加50
            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-300+offsetY);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;{
    if(self.isHeaderViewHide){
        return;
    }else{
        float offsetY = scrollView.contentOffset.y;
        if (offsetY>0) {
              [self upDateView];
            
        }
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsBean*bean  = self.beanArr[indexPath.row];
    [self.delegate creatWebWith:[NSURL URLWithString:bean.detail_link]];
}
-(void)reloadDataWith:(NSString *)type{
    
}
- (HTTPMethod)requestMethod{
    return GET;
}
- (NSString *)createRequestURL{
    return NEWS_API;
}
- (NSMutableDictionary *)createParams{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNow] forKey:@"skip"];
    [params setValue: [NSString stringWithFormat:@"10"] forKey:@"limit"];
    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"category"];
    NSDictionary *typeDic = nil;
    if (!arr||arr.count==0) {
        typeDic = @{};
    }else{
           NSInteger index = [self.tableViewControllers indexOfObject:self.pageController.viewControllers[0]];
           typeDic = arr[self.tableViewControllers.count-index-1];
    }
    NSString *str = typeDic[@"type"];
    if (!str) {
        str = @"tuijian";
    }
    [params setValue:str forKey:@"ctype"];
    return params;
}
#pragma mark PageViewControllerDelegate
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self.tableViewControllers indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.tableViewControllers count]) {
        return nil;
    }
    return self.tableViewControllers[index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self.tableViewControllers indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return self.tableViewControllers[index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    NSArray *arr = pageViewController.viewControllers;
    NSInteger index = [self.tableViewControllers indexOfObject:arr[0]];
    [self category:self.tableViewControllers.count-index];
}
- (void)refreshDatas {
    [self.beanArr removeAllObjects];
    [self requestDatas];
}
#pragma mark RequestDelegate
- (void)requestStart{
    
}
- (void)requestSuccess:(NSDictionary *)dict{
    NSArray *news = [JSONParseManager parse2Array:[NewsBean class] jsonDict:dict arrayKey:@"news"];
    [self.beanArr addObjectsFromArray:news];
    [self.tableView reloadData];
}
- (void)requestFailure:(NSError *)error{
    [ToastUtils showHud:@"暂无网络"];
}
- (void)requestFinish{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark categatory
-(void)category:(NSInteger)tag{
    [self.pageController setViewControllers:@[self.tableViewControllers[self.tableViewControllers.count-tag]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.tableView = nil;
    [self refreshDatas];
    UIScrollView *scr = [self.smallViewHeaderView viewWithTag:1001];
    float offSetX = scr.contentOffset.x;
    [self.view endEditing:YES];
    NSArray *arr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"category"];
    for (NSInteger i = 1; i<arr.count+1; i++) {
        if(i!=tag){
         UIView *view = [self.categoryView viewWithTag:i];
            if ([view isKindOfClass:[categoryBtn class]]){
                categoryBtn *btn = (categoryBtn*)view;
                btn.tittle.textColor = [UIColor colorWithHexString:@"666666"];
                btn.view.backgroundColor = [UIColor clearColor];
            }
        }
        else{
            UIView *view = [self.categoryView viewWithTag:i];
            if ([view isKindOfClass:[categoryBtn class]]){
                categoryBtn *btn = (categoryBtn*)view;
                btn.tittle.textColor = [UIColor colorWithHexString:@"la94fb"];
                btn.view.backgroundColor = [UIColor colorWithHexString:@"la94fb"];
                float frameX = btn.frame.origin.x;
                if((frameX-offSetX)>SCREEN_WIDTH||(frameX-offSetX)<0){
                    [scr setContentOffset:CGPointMake(frameX-120,0)];
                }
            }
        }
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
