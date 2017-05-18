//
//  bookmarkBean.m
//  browser
//
//  Created by pathfinder on 2017/5/4.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "bookmarkBean.h"

@implementation bookmarkBean
-(id)initWithUrlStr:(NSString*)str icon:(NSString*)iconUrlStr title:(NSString*)title{
    if (self = [super init]) {
        self.title=title;
        self.urlStr=str;
        self.iconStr = iconUrlStr;
        return self;
    }
    return nil;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.urlStr = [aDecoder decodeObjectForKey:@"urlStr"];
        self.iconStr = [aDecoder decodeObjectForKey:@"iconStr"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)acoder
{
    [acoder encodeObject:self.title forKey:@"title"];
    [acoder encodeObject:self.urlStr forKey:@"urlStr"];
    [acoder encodeObject:self.iconStr forKey:@"iconStr"];
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[bookmarkBean class]]) {
        bookmarkBean *bean = (bookmarkBean*)object;
        if ([bean.urlStr isEqualToString:self.urlStr]) {
                return YES;
        }
        else{
            return NO;
        }
    }
    else if ([object isKindOfClass:[historyBean class]]){
        historyBean *bean = (historyBean*)object;
        if ([bean.urlStr isEqualToString:self.urlStr]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
    return NO;
}

@end
