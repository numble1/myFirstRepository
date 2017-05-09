//
//  WebViewController.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/9.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "GeneralViewController.h"

@protocol writeTittleDelegate <NSObject>
-(void)writeToTitle:(NSString*)str;
@end

@interface WebViewController : GeneralViewController
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,assign)id <writeTittleDelegate> delegate;
@property(nonatomic,strong)UIWebView *webView;
@end
