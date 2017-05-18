//
//  ToastUtils.h
//  Unity-iPhone
//
//  Created by 张帆 on 16/12/14.
//
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ToastUtils : NSObject

+ (void)showHud:(NSString *)label;

+ (void)showHudWithLaber:(NSString *)title detailLabel:(NSString *)detail offset:(CGPoint)offset duringTime:(float)during fromView:(UIView *)superView;


@end
