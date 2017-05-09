//
//  GDpageViewController.m
//  browser
//
//  Created by pathfinder on 2017/4/25.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "DpageViewController.h"
#import "MainViewController.h"
#import "WebViewController.h"
#import "WindowsViewController.h"
#import "RightViewController.h"
#import "bookmarkBean.h"
#import "bottomView.h"

@interface DpageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,UISearchBarDelegate,writeTittleDelegate,bottomDelegate,searchbarDelegate>
@property(nonatomic,strong) UIPageViewController *pageVC;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic,strong)NSMutableArray *viewControllers;
@property(nonatomic,strong)UIViewController*currentCtrl;
@property (unsafe_unretained,nonatomic)CGRect rect;
@property (weak, nonatomic) IBOutlet UIButton *indexBtn;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property(nonatomic,strong)bottomView *exploreBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWidth;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISearchBar *searbar;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *RefreshBtn;

@end

@implementation DpageViewController
-(bottomView *)exploreBottomView{
    if (!_exploreBottomView) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"bottomView" owner:self options:nil];
        _exploreBottomView = arr[0];
        _exploreBottomView.delegate = self;
    }return _exploreBottomView;
}

-(NSMutableArray *)viewControllers{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
        MainViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MainViewController class])];
        main.delegate = self;
        [_viewControllers addObject:[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RightViewController class])]];
        [_viewControllers addObject:main];
    }
    return _viewControllers;
}
- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        self.pageVC.view.frame = self.mainView.frame;
        [self.view addSubview:_pageVC.view];
//        [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(self.mainView);
//        }];
        for (UIView *subview in _pageVC.view.subviews) {
            [(UIScrollView *)subview setDelegate:self];
            //设置是否支持手势滑动
            //            [(UIScrollView *)subview setScrollEnabled:NO];
            
        }
          [_pageVC setViewControllers:@[self.viewControllers[1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageVC;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hide];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setBtnText:) name:@"setBtnText" object:nil];
    //存储全局变量书签
    NSMutableArray *arr = [NSMutableArray array];
    self.delegate = self.viewControllers[0];
    self.delegate = self.viewControllers[1];
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"bookmarks"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideExploreView) name:@"hideExplore" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endEdit) name:@"endEdit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtnStatus:) name:@"changeBtnStatus" object:nil];
    [self addChildViewController:self.pageVC];
  //  [self.view addSubview:self.pageVC.view];
    [self.view bringSubviewToFront:self.bottomView];
  //  [self.view bringSubviewToFront:self.topView];
}
-(void)setBtnText:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    [self.indexBtn setTitle:dic[@"num"] forState:UIControlStateNormal];
}
- (IBAction)reFreshWebView:(id)sender {
    if ([self.currentCtrl isKindOfClass:[WebViewController class]]) {
        WebViewController *viewCtrl = (WebViewController*)self.currentCtrl;
        [viewCtrl.webView reload];
    }
    else{
        MainViewController *viewCtrl = (MainViewController*)self.currentCtrl;
        [viewCtrl reloadTableView];
    }
}
- (IBAction)collect:(id)sender {
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searbar.placeholder = @"请输入网址";
}
#pragma mark searchBarDelegate
-(void)hide{
    self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.searbar.backgroundImage = [UIImage imageNamed:@"bg"];
  //  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.width.constant=0;
    self.secondWidth.constant=0;
}
-(void)show{
    self.topView.backgroundColor = [UIColor whiteColor];
    self.searbar.backgroundImage = nil;
    // self.view.backgroundColor = [UIColor whiteColor];
    self.width.constant=40;
    self.secondWidth.constant=40;
}
#pragma mark searchDelegat
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    WebViewController *webCtrl = [[WebViewController alloc] init];
    webCtrl.urlStr = [NSString stringWithFormat:@"https://%@",searchBar.text];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Tool
// 根据数组元素，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewControlller{
    return [self.viewControllers indexOfObject:viewControlller];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return self.viewControllers[index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return self.viewControllers[index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    if ([pendingViewControllers.firstObject isKindOfClass:[MainViewController class]]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadView" object:nil];
        self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        self.searbar.backgroundImage = [UIImage imageNamed:@"bg"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
    }
    else{
        self.topView.backgroundColor = [UIColor whiteColor];
        self.searbar.backgroundImage = nil;
        //  self.searbar.backgroundColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];}
}


-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if ([pageViewController.viewControllers.firstObject isKindOfClass:[MainViewController class]]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadView" object:nil];
        self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        self.searbar.backgroundImage = [UIImage imageNamed:@"bg"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    }
    else{
        self.topView.backgroundColor = [UIColor whiteColor];
        self.searbar.backgroundImage = nil;
        //  self.searbar.backgroundColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
  }
}
-(void)endEdit{
    //[self.textField endEditing:YES];
}
#pragma mark editbookmark
-(void)addbookMarkBean:(bookmarkBean *)bookMarkBean{
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"bookmarks"];
    [arr addObject:bookMarkBean];
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"bookmarks"];
}
#pragma mark WriteTittleDelegat
-(void)writeToTitle:(NSString *)str{
  //  self.searchBar.text = str;
}

- (IBAction)backward:(id)sender {
    [self.delegate back];
}
- (IBAction)forward:(id)sender {
    [self.delegate forward];
}
-(void)changeBtnStatus:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    NSString *back = dic[@"back"];
    NSString *forward = dic[@"forward"];
    if ([back isEqualToString:@"true"]) {
        [self.back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        self.back.userInteractionEnabled = YES;
    }
    else{
         [self.back setImage:nil forState:UIControlStateNormal];
        self.back.userInteractionEnabled = NO;
    }
    if ([forward isEqualToString:@"true"]) {
        [self.forward setImage:[UIImage imageNamed:@"下一步"] forState:UIControlStateNormal];
        self.forward.userInteractionEnabled = YES;
    }
    else{
         [self.forward setImage:nil forState:UIControlStateNormal];
        self.forward.userInteractionEnabled = NO;
    }
    
}
- (IBAction)addNewweb:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goHome:(id)sender {
    [self.delegate main];
}
- (IBAction)explore:(id)sender {
    [self showBottomView];
}

-(void)showBottomView{
    self.exploreBottomView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH ,120);
    [self.view addSubview:self.exploreBottomView];
    [UIView animateWithDuration:0.3 animations:^{
        self.exploreBottomView.frame = CGRectMake(0, SCREEN_HEIGHT-120,SCREEN_WIDTH ,120);
    }];
}
-(void)hideExploreView{
//    [self.exploreview removeFromSuperview];
}
#pragma mark bottomViewDelegate
-(void)clear{
    
}
-(void)share{
    
}
-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.exploreBottomView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH ,120);
    }];
}
-(void)set{
}
-(void)bookmark{
    
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
