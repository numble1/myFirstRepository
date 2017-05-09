//
//  AppDelegate.m
//  yd2browser
//
//  Created by yunfenghan Ling on 7/8/16.
//  Copyright © 2016 lingyfh. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [TLRemoteConfig updateRemoteConfig];
    UMConfigInstance.appKey = UMengAPPKey;
    UMConfigInstance.channelId = UMengChannel;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}



@end
