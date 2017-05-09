//
//  bottomView.m
//  browser
//
//  Created by pathfinder on 2017/5/8.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "bottomView.h"

@implementation bottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)dismiss:(id)sender {
    
    [self.delegate dismiss];
}
- (IBAction)bookmark:(id)sender {
    
    [self.delegate bookmark];
}
- (IBAction)clear:(id)sender {
    [self.delegate clear];
}
- (IBAction)share:(id)sender {
    [self.delegate share];
}
- (IBAction)set:(id)sender {
    [self.delegate set];
}

@end
