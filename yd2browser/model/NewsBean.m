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

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.uuid = [aDecoder decodeObjectForKey:@"_id"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.desc = [aDecoder decodeObjectForKey:@"desc"];
    self.src = [aDecoder decodeObjectForKey:@"src"];
    self.detail_link = [aDecoder decodeObjectForKey:@"detail_link"];
    self.time = [aDecoder decodeObjectForKey:@"atime"] ;
    self.icon = [aDecoder decodeObjectForKey:@"icon"];
    self.category = [aDecoder decodeObjectForKey:@"category"];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.uuid forKey:@"_id"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeObject:self.src forKey:@"src"];
    [coder encodeObject:self.detail_link forKey:@"detail_link"];
    [coder encodeObject:self.time forKey:@"atime"];
    [coder encodeObject:self.icon forKey:@"icon"];
    [coder encodeObject:self.category forKey:@"category"];
}


@end
