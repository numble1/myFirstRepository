//
//  GDpageViewController.h
//  browser
//
//  Created by pathfinder on 2017/4/25.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol webDelegate <NSObject>
-(void)back;
-(void)forward;
@end



@interface DpageViewController : UIViewController
@property(nonatomic,weak)id <webDelegate>delegate ;
//暴露在外面方便其他控制器获取判断
@property(nonatomic,strong) UIPageViewController *pageVC;
@property (nonatomic,strong)NSMutableArray *viewControllers;
-(void)creatWebWith:(NSURL *)url;
@end
