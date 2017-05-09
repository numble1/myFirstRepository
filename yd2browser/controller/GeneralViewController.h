//
//  GeneralViewController.h
//  ddemtion
//
//  Created by yunfenghan Ling on 16/3/8.
//  Copyright © 2016年 lingyfh. All rights reserved.
//

#import "BaseViewController.h"
#import "LoadingUtil.h"

#define PARAM_SKIP @"skip"
#define PARAM_LIMIT @"limit"

@protocol RequestDelegate <NSObject>

- (void)requestStart;
- (void)requestSuccess:(NSDictionary *)dict;
- (void)requestFailure:(NSError *)error;
- (void)requestFinish;

@end

@interface GeneralViewController : BaseViewController <RequestDelegate>

@property (nonatomic, assign) id<RequestDelegate> requestDelegate;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableArray *items;

#pragma mark -
- (BOOL)needInitItems;
- (BOOL)needNotify;

- (BOOL)autoShowLoadingView;
- (UIView *)showLoadingViewSuperView;

- (BOOL)autoShowLoadingFailView;
- (UIView *)showLoadingFailViewSuperView;

#pragma mark -
- (HTTPMethod)requestMethod;
- (void)requestDatas;
- (NSString *)createRequestURL;
- (NSMutableDictionary *)createParams;
- (IBAction)back:(id)sender;

- (void)refreshDatas;

- (void)retryRequest;

- (void)clearCurrentImage;
- (void)resetCurrentImage;

- (void)notifyAction:(id)sender;
- (void)receiveNotify:(id)sender;

@end
