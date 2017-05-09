//
//  JSONParseManager.m
//  ddemtion
//
//  Created by yunfenghan Ling on 16/3/10.
//  Copyright © 2016年 lingyfh. All rights reserved.
//

#import "JSONParseManager.h"
#import "baseBean.h"

@implementation JSONParseManager

+ (baseBean *) parse2Bean:(Class)cls jsonDict:(NSDictionary *)dict itemKey:(NSString *)key {
    NSDictionary *resDict = [self parse2ResDict:dict];
    if (resDict) {
        NSDictionary *itemDict = [resDict valueForKey:key];
        baseBean *bean = [[cls alloc] initWithDictionary:itemDict];
        return bean;
    }
    return nil;
}

+ (NSArray *) parse2Array:(Class)cls jsonDict:(NSDictionary *)dict {
    return [self parse2Array:cls jsonDict:dict arrayKey:@"data"];
}

+ (NSArray *) parse2Array:(__kindof baseBean *)cls jsonDict:(NSDictionary *)dict arrayKey:(NSString *)arrayKey {
    NSDictionary *resDict = [self parse2ResDict:dict];
    if (resDict) {
        NSArray *data = [self parse2Array:resDict arrayKey:arrayKey];
        NSMutableArray *rsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [data count]; i++) {
            baseBean *bean = [[cls alloc] initWithDictionary:[data objectAtIndex:i]];
            [rsArray addObject:bean];
        }
        return rsArray;
    }
    return nil;
}

+ (NSDictionary *)parse2ResDict:(NSDictionary *) dict {
    return [dict valueForKey:@"res"];
}

+ (NSArray *)parse2Array:(NSDictionary *)dict arrayKey:(NSString *)arrayKey {
    return [dict valueForKey:arrayKey];
}

+ (int) parse2Code:(NSDictionary *)dict {
    if (!dict) {
        return -1;
    }
    NSNumber *code = (NSNumber *)[dict valueForKey:@"code"];
    if (code) {
        return [code intValue];
    }
    return 0;
}


+ (NSString *) parse2Msg:(NSDictionary *)dict {
    if (!dict) {
        return @"网络错误";
    }
    NSString *msg = [dict valueForKey:@"msg"];
    if (msg && ![msg isEqual:[NSNull null]]) {
        return [NSString stringWithFormat:@"%@", msg];
    }
    return @"操作失败，未知异常";
}

@end
