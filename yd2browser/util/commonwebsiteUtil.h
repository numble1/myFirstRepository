//
//  commonwebsiteUtil.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/15.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commonwebsiteUtil : NSObject
+(NSArray*)getCommonWebsite;
+(void)addCommonWebSite:(NSDictionary*)dic;
+(void)removeWebsite:(NSDictionary*)dic;
@end
