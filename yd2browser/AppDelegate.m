//
//  AppDelegate.m
//  yd2browser
//
//  Created by yunfenghan Ling on 7/8/16.
//  Copyright © 2016 lingyfh. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import<CoreLocation/CoreLocation.h>
#import "TaoLuData.h"
@import TLRemoteConfig;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    CLLocationManager* location = [CLLocationManager new];
    [location requestAlwaysAuthorization];
    [TLRemoteConfig updateRemoteConfig];
    UMConfigInstance.appKey = UMengAPPKey;
    UMConfigInstance.channelId = UMengChannel;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [TLRemoteConfig updateRemoteConfig];
    [self updateCategory];
    NSLog(@"%@",[TLRemoteConfig localConfig]);
    return YES;
}
-(void)updateCategory{
    [[AFNetwork shareManager] requestWithMethod:GET url:@"http://service.newsad.adesk.com/v1/category" params:nil success:^(NSURLSessionDataTask *task, NSDictionary *dict){
        NSDictionary *dic = dict[@"res"];
        NSArray *arr = dic[@"category"];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"category"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [ToastUtils showHud:@"获取分类失败"];
    } finish:^{
        
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
       [TLRemoteConfig updateRemoteConfig];
}



@end
