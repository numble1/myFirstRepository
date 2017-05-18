//
//  mainViewController.h
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralViewController.h"
@protocol safariDelegate<NSObject>
-(void)creatWebWith:(NSURL*)url;

@end

@interface MainViewController : GeneralViewController
@property(nonatomic,weak)id <safariDelegate>delegate;
-(void)reloadTableView;

@end
