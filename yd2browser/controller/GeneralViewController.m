//
//  GeneralViewController.m
//  ddemtion
//
//  Created by yunfenghan Ling on 16/3/8.
//  Copyright © 2016年 lingyfh. All rights reserved.
//

#import "GeneralViewController.h"
#import "LoadingUtil.h"

#define Notify_NAME @"notify_transfer"
#define Text_Loading @"数据加载中"
#define Text_Loading_FAIL @"加载失败，请稍后重试"
#define Text_Loading_FAIL_TRY @"加载失败，点击重试"

@interface GeneralViewController () <UIGestureRecognizerDelegate>
{
    BOOL requestEnd;
}
@end


@implementation GeneralViewController

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    PLog(@"viewWillAppear self = %@", self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetCurrentImage];
    PLog(@"viewDidAppear self = %@", self);
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self clearCurrentImage];
    PLog(@"viewDidDisappear self = %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    PLog(@"viewDidLoad self = %@", self);
    if ([self needInitItems]) {
        _items = [[NSMutableArray alloc] init];
    }
    
    requestEnd = true;
    _requestDelegate = self;
    
    if ([self needNotify]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify:) name:Notify_NAME object:nil];
    }
    
    // Do any additional setup after loading the view.
}



- (BOOL)needNotify {
    return NO;
}

- (BOOL)needInitItems {
    return YES;
}

#pragma mark -

- (BOOL)autoShowLoadingView {
    return true;
}

- (UIView *)showLoadingViewSuperView {
    return self.view;
}

- (BOOL)autoShowLoadingFailView {
    return true;
}

- (UIView *)showLoadingFailViewSuperView {
    return self.view;
}

#pragma mark -
- (void)retryRequest {
    PLog(@"request failure try");
    if ([self autoShowLoadingFailView]) {
        [LoadingUtil hide:[self showLoadingFailViewSuperView] animated:YES];
    }
}

#pragma mark - RequestDelegate
- (void)requestStart {
    PLog(@"request start");
    if ([self autoShowLoadingFailView]) {
        [LoadingUtil hide:[self showLoadingFailViewSuperView] animated:YES];
    }
    if ([self autoShowLoadingView] && [_items count] == 0) {
        [LoadingUtil show:[self showLoadingViewSuperView] animated:NO msg:Text_Loading hudBg:[UIColor whiteColor]];
    }
}

- (void)requestSuccess:(NSDictionary *)dict {
    PLog(@"request success");
}

- (void)requestFailure:(NSError *)error {
    PLog(@"request failure error = %@", error);
    if ([self autoShowLoadingFailView]) {
        [LoadingUtil showLoadingRs:[self showLoadingFailViewSuperView] animated:YES msg:Text_Loading_FAIL_TRY target:self action:@selector(retryRequest)];
    }
}

- (void)requestFinish {
    PLog(@"request finish");
    if ([self autoShowLoadingView]) {
        [LoadingUtil hide:[self showLoadingViewSuperView] animated:NO];
    }
}

#pragma mark - 网络请求相关

- (HTTPMethod)requestMethod {
    return GET;
}

- (void)refreshDatas {
    PLog(@"refresh datas");
}

- (NSString *)createRequestURL {
    return @"";
}

- (NSMutableDictionary *)createParams {
    return [[NSMutableDictionary alloc] init];
}

- (void)requestDatas {
    PLog(@"general request datas requestEnd = %d", requestEnd);
    if (!requestEnd) {
        return;
    }
    
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(requestStart)]) {
        [_requestDelegate requestStart];
    }
    PLog(@"general request datas");
    requestEnd = false;
    NSString *url = [self createRequestURL];
    NSMutableDictionary *params = [self createParams];
    
    [[AFNetwork shareManager] requestWithMethod:[self requestMethod] url:url params:params success:^(NSURLSessionDataTask *task, NSDictionary *dict) {
        if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(requestSuccess:)]) {
            [_requestDelegate requestSuccess:dict];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(requestFailure:)]) {
            [_requestDelegate requestFailure:error];
        }
    } finish:^{
        if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(requestFinish)]) {
            [_requestDelegate requestFinish];
        }
        requestEnd = true;
    }];
}

#pragma mark -
- (IBAction)back:(id)sender {
    PLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notify
- (void)receiveNotify:(id)sender {
    PLog(@"receive notify action id = %@", sender);
}

- (void)notifyAction:(id)sender {
    PLog(@"notify action id = %@", sender);
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_NAME object:sender userInfo:nil];
}

#pragma mark - 
- (void)clearCurrentImage {
    
}

- (void)resetCurrentImage {
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    //判断是否为rootViewController
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    PLog(@"did receive memory warning");
    [[SDImageCache sharedImageCache] clearMemory];
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
