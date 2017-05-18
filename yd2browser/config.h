//
//  config.h
//  yd2browser
//
//  Created by yunfenghan Ling on 7/8/16.
//  Copyright © 2016 lingyfh. All rights reserved.
//

#import <FFastlib/FFastlib.h>
#import "UMMobClick/MobClick.h"
#import <iCarousel/iCarousel.h>

#pragma mark -

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// 阿里百川appkey
#define FeedBackAppKey @""
// umeng appkey
#define UMengAPPKey @""
// umeng channel
#define NEWS_API @"http://service.newsad.adesk.com/v1/categorynews"
#define UMengChannel @"AppStore"
#define HISTORY @"history"
#define BOOKMARKS @"bookmarks"
#define COMMONWEBSITE @"commonwebsite"
#define KWINDOW [UIApplication sharedApplication].delegate.window
@import TLRemoteConfig;
