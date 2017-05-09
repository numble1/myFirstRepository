//
//  LoadingUtil.m
//  ddemtion
//
//  Created by LingYunfenghan on 3/19/16.
//  Copyright © 2016 lingyfh. All rights reserved.
//

#import "LoadingUtil.h"

#define MBProgressHUDTag -1047



@implementation LoadingUtil
+ (MBProgressHUD *)showGenerLoading:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    [hud setLabelText:msg];
    return hud;
}


+ (MBProgressHUD *)show:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg {
    return [self show:view animated:animated msg:msg hudBg:nil];
}

+ (MBProgressHUD *)show:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg hudBg:(UIColor *)color {
    
    NSArray<UIImage *> *images = @[[UIImage imageNamed:@"loading1.png"], [UIImage imageNamed:@"loading2.png"]];
    
    UIImageView *customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 118, 80)];
    [customView setAnimationImages:images];
    [customView setAnimationDuration:0.4];
    [customView startAnimating];
    [customView setContentMode:UIViewContentModeScaleAspectFit];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    [hud setCustomView:customView];
    [hud setMode:MBProgressHUDModeCustomView];
    if (msg && ![msg isEqual:[NSNull null]] && msg.length > 0) {
        [hud setLabelText:msg];
    }
    [hud setTag:MBProgressHUDTag];
    [hud setColor:[UIColor whiteColor]];
    [hud setLabelColor:[UIColor blackColor]];
    [hud setLabelFont:[UIFont systemFontOfSize:12]];
    if (color) {
        [hud setBackgroundColor:color];
    }
    return hud;
}

+ (BOOL)hide:(UIView *)view animated:(BOOL)animated {
    return [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (MBProgressHUD *)loadingView:(UIView *)superView {
    UIView *view = [superView viewWithTag:MBProgressHUDTag];
    if ([view isKindOfClass:[MBProgressHUD class]]) {
        return (MBProgressHUD *)view;
    }
    return nil;
}

#pragma mark -
+ (MBProgressHUD *)showEmpty:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 200)];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    [imageView setImage:[UIImage imageNamed:@"empty_icon.png"]];
    [customView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 30));
        make.centerX.equalTo(customView);
        make.centerY.equalTo(customView).with.offset(-25);
    }];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    [msgLabel setText:msg];
    [customView addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(customView);
        make.centerY.equalTo(imageView).with.offset(33);
    }];
    [msgLabel setFont:[UIFont systemFontOfSize:14]];
    [msgLabel setTextColor:UIColorFromRGB(0x666666)];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    [hud setCustomView:customView];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setColor:[UIColor whiteColor]];
    [hud setBackgroundColor:[UIColor whiteColor]];
    return hud;
}

#pragma mark -

+ (MBProgressHUD *)showLoadingRs:(UIView *)view animated:(BOOL)animated msg:(NSString *)msg target:(id)target action:(SEL)action {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setContentMode:UIViewContentModeCenter];
    [label setText:msg];
    [customView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(customView).with.offset(0);
        make.centerY.equalTo(customView).with.offset(0);
    }];
    [hud setCustomView:customView];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setColor:[UIColor whiteColor]];
    [hud setMargin:0];
    [hud setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [hud addGestureRecognizer:tapGesure];
    return hud;
}

@end
