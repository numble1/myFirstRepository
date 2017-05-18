//
//  searchViewController.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/10.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralViewController.h"
#import "MainViewController.h"
#import "DpageViewController.h"

@interface searchViewController : GeneralViewController
@property(nonatomic,strong)MainViewController *main;
@property(nonatomic,strong)DpageViewController *DpageC;
@property(nonatomic,strong)NSString *textFieldStr;
@end
