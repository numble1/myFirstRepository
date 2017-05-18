//
//  ToastUtils.m
//  Unity-iPhone
//
//  Created by 张帆 on 16/12/14.
//
//

#import "ToastUtils.h"

@implementation ToastUtils

+ (void)showHud:(NSString *)label{
    
    [ToastUtils showHudWithLaber:label detailLabel:nil offset:CGPointMake(0, 120) duringTime:2 fromView:KWINDOW];
    
}

+ (void)showHudWithLaber:(NSString *)title detailLabel:(NSString *)detail offset:(CGPoint)offset duringTime:(float)during fromView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.labelText = title;
        hud.xOffset = offset.x;
        hud.yOffset = offset.y;
        hud.margin = 10;
        hud.detailsLabelText = detail;
        [hud hide:YES afterDelay:during];
    });
    
}





@end
