//
//  BaseCtrl.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/9.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "GeneralViewController.h"

@interface BaseCtrl : GeneralViewController
@property (nonatomic,strong)NSMutableArray *beanArr;
-(void)reloadTableView;
- (void)fetchDataWithskip:(NSInteger)skip andWithlimit:(NSInteger)limit;
-(void)loadMore;
@end
