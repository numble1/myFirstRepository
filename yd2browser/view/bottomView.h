//
//  bottomView.h
//  browser
//
//  Created by pathfinder on 2017/5/8.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol bottomDelegate <NSObject>

-(void)clear;
-(void)bookmark;
-(void)share;
-(void)set;
-(void)dismiss;

@end


@interface bottomView : UIView
@property(nonatomic,assign)id<bottomDelegate>delegate;
@end
