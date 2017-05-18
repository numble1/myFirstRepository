//
//  historyBean.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/11.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "historyBean.h"

@implementation historyBean

-(id)initWithUrlStr:(NSString*)str icon:(NSString*)iconUrlStr title:(NSString*)title{
    if (self = [super init]) {
        self.title=title;
        self.urlStr=str;
        self.iconStr = iconUrlStr;
        return self;
    }
    return nil;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.urlStr = [aDecoder decodeObjectForKey:@"urlStr"];
        self.iconStr = [aDecoder decodeObjectForKey:@"iconStr"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.urlStr forKey:@"urlStr"];
    [aCoder encodeObject:self.iconStr forKey:@"iconStr"];
}
@end
