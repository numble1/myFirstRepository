//
//  categoryBtn.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/10.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol categoryDelegate <NSObject>

-(void)category:(NSInteger)tag;

@end

@interface categoryBtn : UIView
@property (weak, nonatomic) IBOutlet UILabel *tittle;
@property (weak, nonatomic) IBOutlet UIView *view;
@property(nonatomic,assign)id <categoryDelegate> delegate;
@end
