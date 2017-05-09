//
//  JSONParseManager.h
//  ddemtion
//
//  Created by yunfenghan Ling on 16/3/10.
//  Copyright © 2016年 lingyfh. All rights reserved.
//

#import "baseBean.h"

@interface JSONParseManager : NSObject

+ (baseBean *) parse2Bean:(Class)cls jsonDict:(NSDictionary *)dict itemKey:(NSString *)key;
+ (NSArray *) parse2Array:(Class)cls jsonDict:(NSDictionary *)dict;
+ (NSArray *) parse2Array:(Class)cls jsonDict:(NSDictionary *)dict arrayKey:(NSString *)arrayKey;

+ (int) parse2Code:(NSDictionary *)dict;
+ (NSString *) parse2Msg:(NSDictionary *)dict;

@end
