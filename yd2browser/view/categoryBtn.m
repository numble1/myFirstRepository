//
//  categoryBtn.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/10.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "categoryBtn.h"

@implementation categoryBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)click:(id)sender {
    self.tittle.textColor = [UIColor colorWithHexString:@"la94fb"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"la94fb"];
    [self.delegate category:self.tag];
}

@end
