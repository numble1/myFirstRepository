//
//  mainViewController.h
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCtrl.h"

@protocol searchbarDelegate <NSObject>
//动态显示左右按钮
-(void)hide;
-(void)show;

@end

@interface MainViewController : BaseCtrl
@property(nonatomic,assign)id <searchbarDelegate>delegate;
-(void)reloadTableView;

@end
