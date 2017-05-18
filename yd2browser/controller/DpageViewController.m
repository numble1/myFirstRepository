//
//  GDpageViewController.m
//  browser
//
//  Created by pathfinder on 2017/4/25.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "DpageViewController.h"
#import "MainViewController.h"
#import "WindowsViewController.h"
#import "WebViewController.h"
#import "RightViewController.h"
#import "bookmarkBean.h"
#import "bottomView.h"
#import "bookMarkEditViewController.h"
#import "SetViewController.h"
#import "clearViewController.h"
#import "iOSNativeShare.h"

#define animateTime 2
@interface DpageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,UISearchBarDelegate,bottomDelegate,safariDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property(nonatomic,strong)UIViewController*currentCtrl;
@property (unsafe_unretained,nonatomic)CGRect rect;
@property (weak, nonatomic) IBOutlet UIButton *indexBtn;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property(nonatomic,strong)bottomView *exploreBottomView;


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
         [_viewControllers addObject:main];
        RightViewController *right = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RightViewController class])];
        right.DpageC = self;
        [_viewControllers addObject:right];
    }
    return _viewControllers;
}
- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        self.pageVC.view.frame =SCREEN_BOUNDS;
        [self.view addSubview:_pageVC.view];
//        [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(self.mainView);
//        }];
        for (UIView *subview in _pageVC.view.subviews) {
            [(UIScrollView *)subview setDelegate:self];
            //设置是否支持手势滑动
            //           [(UIScrollView *)subview setScrollEnabled:NO];
        }
          [_pageVC setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageVC;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark safariDelegate
-(void)creatWebWith:(NSURL *)url{
    WebViewController *web = nil;
    if (self.viewControllers.count == 2) {
        web = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [self.viewControllers insertObject:web atIndex:0];
        web.DpageC = self;
        web.url=url;
    }
    else{
        web = self.viewControllers[0];
        web.url=url;
        [web reload];
    }
    [_pageVC setViewControllers:@[web] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"返回";
    [self hide];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setBtnText:) name:@"setBtnText" object:nil];
    self.delegate = self.viewControllers[0];
    self.delegate = self.viewControllers[1];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideExploreView) name:@"hideExplore" object:nil];
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

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
}

#pragma mark searchBarDelegate
-(void)hide{
//    [UIView animateWithDuration:animateTime animations:^{
//        self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//        self.searbar.backgroundImage = [UIImage imageNamed:@"bg"];
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//    }];
   
}
-(void)show{
//    [UIView animateWithDuration:animateTime animations:^{
//    self.topView.backgroundColor = [UIColor clearColor];
//    self.searbar.backgroundImage = nil;
//    self.view.backgroundColor = [UIColor clearColor];}];
   
}
#pragma mark searchDelegat
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    WebViewController *webCtrl = [[WebViewController alloc] init];
//    webCtrl.urlStr = [NSString stringWithFormat:@"https://%@",searchBar.text];
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




-(void)endEdit{
    //[self.textField endEditing:YES];
}


/*前进回退逻辑
 在网页内goback goforward
 在网页外就是pageviewcontrollers的切换
 */
 - (IBAction)backward:(id)sender {
    if ([self.pageVC.viewControllers[0] isKindOfClass:[MainViewController class]]) {
       // [self.pageVC setViewControllers:@[self.viewControllers[self.viewControllers.count-1]] direction:  UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    else{
    [self.delegate back];
    }
}
- (IBAction)forward:(id)sender {
    if ([self.pageVC.viewControllers[0] isKindOfClass:[RightViewController class]]) {
     //   [self.pageVC setViewControllers:@[self.viewControllers[self.viewControllers.count-2]] direction:  UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    else if ([self.pageVC.viewControllers[0] isKindOfClass:[MainViewController class]]){
        [self.pageVC setViewControllers:@[self.viewControllers[self.viewControllers.count-3]] direction:  UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    else{
    [self.delegate forward];
    }
}
-(void)changeBtnStatus:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    NSString *webload = dic[@"webload"];
    if (([self.pageVC.viewControllers[0] isKindOfClass:[MainViewController class]]||[self.pageVC.viewControllers[0] isKindOfClass:[RightViewController class]])&&[webload isEqualToString:@"true"]) {
        return;
    }
    NSString *back = dic[@"back"];
    NSString *forward = dic[@"forward"];
    if ([back isEqualToString:@"true"]) {
        [self.back setImage:[UIImage imageNamed:@"previous_click"] forState:UIControlStateNormal];
        self.back.userInteractionEnabled = YES;
    }
    else{
         [self.back setImage:[UIImage imageNamed:@"previous_unclick"] forState:UIControlStateNormal];
        self.back.userInteractionEnabled = NO;
    }
    if ([forward isEqualToString:@"true"]) {
        [self.forward setImage:[UIImage imageNamed:@"next_click"] forState:UIControlStateNormal];
        self.forward.userInteractionEnabled = YES;
    }
    else{
         [self.forward setImage:[UIImage imageNamed:@"next_unclick"] forState:UIControlStateNormal];
        self.forward.userInteractionEnabled = NO;
    }
    
}
- (IBAction)addNewweb:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goHome:(id)sender {
    if (self.viewControllers.count==2) {
         [self.pageVC setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    else{
         [self.pageVC setViewControllers:@[self.viewControllers[self.viewControllers.count-2]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadView" object:nil];
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
     [self dismiss];
    self.title = @"清除数据";
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"clearViewController"] animated:YES];
}
-(void)share{
     [self dismiss];
     [iOSNativeShare shareText:@"发现一个很有用的浏览器软件，快来下载吧 itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1225872208"];
}
-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.exploreBottomView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH ,120);
    }];
}
-(void)set{
     [self dismiss];
      self.title = @"设置";
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SetViewController"] animated:YES];
}
-(void)bookmark{
    [self dismiss];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"bookMarkEditViewController"] animated:YES];
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
