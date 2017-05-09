//
//  LoadingUtil.h
//  ddemtion
//
//  Created by LingYunfenghan on 3/19/16.
//  Copyright © 2016 lingyfh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^clickTryBlock)();

@interface LoadingUtil : NSObject

+ (MBProgressHUD *)showGenerLoading:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg;

+ (MBProgressHUD *)show:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg;
+ (MBProgressHUD *)show:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg hudBg:(UIColor *)color;
+ (BOOL)hide:(UIView *)view animated:(BOOL)animated;
+ (MBProgressHUD *)loadingView:(UIView *)superView;

#pragma mark -
+ (MBProgressHUD *)showLoadingRs:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg target:(id)target action:(SEL)action;

#pragma mark -
+ (MBProgressHUD *)showEmpty:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg;

@end
