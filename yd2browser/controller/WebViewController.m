//
//  WebViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/9.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "WebViewController.h"
#import "DpageViewController.h"
#import "bookmarkBean.h"
#import "searchViewController.h"

@interface WebViewController () <UIWebViewDelegate,webDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *iconStr;
@property(nonatomic,strong)NSString *titleStr;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@end

@implementation WebViewController
- (IBAction)collect:(id)sender {
   
    bookmarkBean *bean = [[bookmarkBean alloc]initWithUrlStr:_urlStr icon:_iconStr title:_titleStr];
    if (!_urlStr&&!_titleStr) {
        [ToastUtils showHud:@"添加书签失败"];
        return;
    }
    [bookMarkUtil addbookMarkBean:bean];
    [ToastUtils showHud:@"添加书签成功"];
    self.collectionImage.image = [UIImage imageNamed:@"topbar_shuqian_select"];
}
- (IBAction)refresh:(id)sender {
    [self reload];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}
-(void)reFresheCollectionImage{
    NSArray *arr = [bookMarkUtil getBookMark];
    self.collectionImage.image = [UIImage imageNamed:@"topbar_shuqian_unselect"];
    for (bookmarkBean * bean in arr) {
        if ([self.url.absoluteString isEqualToString:bean.urlStr]) {
            self.collectionImage.image = [UIImage imageNamed:@"topbar_shuqian_select"];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    _webView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    tap.delegate = self;
    [self.webView addGestureRecognizer:tap];
    self.DpageC.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    UISwipeGestureRecognizer *swipe= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    swipe.delegate = self;
    [self.webView addGestureRecognizer:swipe];
}
-(void)viewWillAppear:(BOOL)animated{
    [self reFresheCollectionImage];
}
-(void)viewDidAppear:(BOOL)animated{
 //   能返回上级是返回上级 不能返回时 退到rightViewcontroller
 //   if (self.webView.canGoBack) {
        if (self.webView.canGoForward) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"true"}];
        }
        else{
             [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"false"}];
        }
 //   }
    //
//    else{
//        if (self.webView.canGoForward) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"true"}];
//        }
//        else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"false"}];
//        }
//    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField endEditing:YES];
    searchViewController *searchC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    searchC.DpageC = self.DpageC;
    searchC.textFieldStr = textField.text;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController: searchC];
    [self presentViewController:navi animated:NO completion:nil];
}
-(void)click{
    [self.view endEditing:YES];
}
-(void)reload{
      [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)back{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else{
        [self.DpageC.pageVC setViewControllers:@[self.DpageC.viewControllers[self.DpageC.viewControllers.count-2]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}
-(void)forward{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"false"}];
    }
}
//判断是否字符串
- (BOOL)isUrlString:(NSString*)str {
    NSString *emailRegex = @"[a-zA-z]+://.*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

//加载完成之前不允许响应点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //判断是否是单击
    //    if (self.couldLoadWeb)
    //    {
    //        ViewController*webCtrl = [[ViewController alloc]init];
    //        webCtrl.urlStr = request.URL.absoluteString;
    //        [self.delegate pushToViewController:webCtrl];
    //        return NO;
    //    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    }
- (void)webViewDidFinishLoad:(UIWebView *)webView{
       self.textField.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (!webView.isLoading) {
            NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
            BOOL complete = [readyState isEqualToString:@"complete"];
            if (complete) {
                [self reFresheCollectionImage];
                NSString *tittle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
                NSString *mainName = [webView stringByEvaluatingJavaScriptFromString:@"document.location.hostname"];
                self.titleStr = tittle;
//                NSLog(@"urlStr: %@",webView.request.mainDocumentURL.absoluteString);
//                NSLog(@"mainName: %@",mainName);
//                NSLog(@"image: %@",image);
                self.iconStr = [webView stringByEvaluatingJavaScriptFromString:@"document.favicon.ico"];
//                NSLog(@"icon %@",self.iconStr);
                self.urlStr = webView.request.URL.absoluteString;
                //记录常用网址
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(1),@"count",mainName,@"websiteId",tittle,@"tittle",webView.request.mainDocumentURL.absoluteString,@"urlStr",nil];
                [commonwebsiteUtil addCommonWebSite:dic];
                historyBean *bean = [[historyBean alloc]initWithUrlStr:_urlStr icon:_iconStr title:_titleStr];
                if (!_urlStr&&!_titleStr) {
                     [historyUtil addHistory:bean];
                }
            }
        }
    if (webView.canGoForward) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"back":@"true",@"forward":@"true",@"webload":@"true"}];
    }
    else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeBtnStatus" object:nil userInfo:@{@"forward":@"false",@"back":@"true",@"webload":@"true"}];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

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
