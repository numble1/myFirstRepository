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
-(void)main;
@end



@interface DpageViewController : UIViewController
@property(nonatomic,assign)id <webDelegate>delegate ;
@end
