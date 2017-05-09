//
//  WebViewController.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/9.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [UIScreen mainScreen].bounds;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, rect.size.width, rect.size.height)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    //用了判断是否是点击进入网页
    //     self.couldLoadWeb  = NO;
}
//加载完成之前不允许响应点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *tittle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.delegate writeToTitle:tittle];
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
    //    if (!webView.isLoading) {
    //        NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    //     NSString* str = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('adpic')[0].style.display = 'none'"];
    //        NSLog(@"打印%@",str);
    //        BOOL complete = [readyState isEqualToString:@"complete"];
    //        if (complete) {
    //            self.couldLoadWeb = YES;
    //        }
    //    }
    
    
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
