//
//  WebViewController.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/9.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "GeneralViewController.h"
#import "DpageViewController.h"

@interface WebViewController : GeneralViewController
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,strong)DpageViewController *DpageC;
-(void)reload;
@end
