//
//  WallpaperBean.m
//  yd2xinwen
//
//  Created by Lacuna on 16/6/7.
//  Copyright © 2016年 f. All rights reserved.
//

#import "NewsBean.h"

@implementation NewsBean

- (void)configFiled:(NSDictionary *)dict {
    self.uuid = [dict valueForKey:@"id"];
    self.name = [dict valueForKey:@"title"];
    self.desc = [dict valueForKey:@"type"];
    self.src = [dict valueForKey:@"name"];
    self.detail_link = [dict valueForKey:@"url"];
    self.time = [dict valueForKey:@"time"];
    self.icon = [dict valueForKey:@"img_url"];
    self.category = [NSArray array];//[dict valueForKey:@"img_url"];
}



@end
