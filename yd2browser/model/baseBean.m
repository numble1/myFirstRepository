//
//  baseBean.m
//  browser
//
//  Created by pathfinder on 2017/4/24.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "baseBean.h"

@implementation baseBean
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self configFiled:dict];
        return self;
    }
    return nil;
}

- (void)configFiled:(NSDictionary *)dict {
}

@end
