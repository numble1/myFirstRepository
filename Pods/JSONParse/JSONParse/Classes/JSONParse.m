//
//  JSONParse.m
//  Pods
//
//  Created by yunfenghan Ling on 3/2/17.
//
//

#import "JSONParse.h"

#define NSNUMBER_def [NSNumber numberWithInt:0]

@implementation JSONParse

+ (BOOL)objIsNull:(id)obj {
    if (!obj || obj == nil || [obj isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)stringToNSDictionary:(NSString *)jsonString {
    return [self stringToNSDictionary:jsonString defValue:@{}];
}

+ (NSDictionary *)stringToNSDictionary:(NSString *)jsonString defValue:(NSDictionary *)def {
    if (![jsonString isKindOfClass:[NSString class]]) {
        return [self objIsNull:def] ? @{} : def;
    }
    if ([self objIsNull:jsonString]) {
        return [self objIsNull:def] ? @{} : def;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if ([self objIsNull:err]) {
        return dict;
    }
    return [self objIsNull:def] ? @{} : def;;
}

+ (NSString *)dictToNSString:(NSDictionary *)dict {
    return [self dictToNSString:dict defValue:@""];
}

+ (NSString *)dictToNSString:(NSDictionary *)dict defValue:(NSString *)def {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return [self objIsNull:def] ? @{} : def;
    }
    if ([self objIsNull:dict]) {
        return [self objIsNull:def] ? @{} : def;
    }
    NSError *err;
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    if ([self objIsNull:err]) {
        return [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
    }
    return [self objIsNull:def] ? @{} : def;
}


#pragma mark -
#pragma mark JSON Parse

+ (NSString *)optString:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optString:dict valueForKey:key defValue:@""];
}

+ (NSDictionary *)optNSDictionary:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optNSDictionary:dict valueForKey:key defValue:@{}];
}

+ (NSArray *)optNSArray:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optNSArray:dict valueForKey:key defValue:@[]];
}


+ (NSNumber *)optNSNumber:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optNSNumber:dict valueForKey:key defValue:NSNUMBER_def];
}

+ (BOOL)optBOOL:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optBOOL:dict valueForKey:key defValue:NO];
}

+ (Boolean)optBoolean:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optBoolean:dict valueForKey:key defValue:NO];
}

+ (int)optInt:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optInt:dict valueForKey:key defValue:0];
}

+ (float)optFloat:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optFloat:dict valueForKey:key defValue:0];
}

+ (double)optDouble:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optDouble:dict valueForKey:key defValue:0];
}

+ (long)optLong:(NSDictionary *)dict valueForKey:(NSString *)key {
    return [self optLong:dict valueForKey:key defValue:0];
}

#pragma mark -
#pragma mark opt has def value

+ (id)parseValue:(NSDictionary *)dict key:(NSString *)key defValue:(id)def{
    if ([self objIsNull:dict]) {
        return def;
    }
    
    id value = [dict valueForKey:key];
    if ([self objIsNull:value]) {
        return def;
    }
    
    if (![value isKindOfClass:[def classForCoder]]) {
        return def;
    }
    return value;
}

+ (NSString *)optString:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSString *)def {
    if ([self objIsNull:def]) {
        def = @"";
    }
    return [self parseValue:dict key:key defValue:def];
}

+ (NSDictionary *)optNSDictionary:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSDictionary *)def {
    if ([self objIsNull:def]) {
        def = @{};
    }
    return [self parseValue:dict key:key defValue:def];
}

+ (NSArray *)optNSArray:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSArray *)def {
    if ([self objIsNull:def]) {
        def = @[];
    }
    return [self parseValue:dict key:key defValue:def];
}

+ (NSNumber *)optNSNumber:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSNumber *)def {
    if ([self objIsNull:def]) {
        def = NSNUMBER_def;
    }
    return [self parseValue:dict key:key defValue:def];
}

+ (BOOL)optBOOL:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(BOOL)def {
    NSNumber *defNum = [NSNumber numberWithInt: def ? 1 : 0];
    NSNumber *rsNum = [self parseValue:dict key:key defValue:defNum];
    return rsNum.boolValue;
}

+ (Boolean)optBoolean:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(Boolean)def {
    return [self optBOOL:dict valueForKey:key defValue:def];
}

+ (int)optInt:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(int)def {
    NSNumber *defNum = [NSNumber numberWithInt: def];
    NSNumber *rsNum = [self parseValue:dict key:key defValue:defNum];
    return rsNum.intValue;
}

+ (float)optFloat:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(float)def {
    NSNumber *defNum = [NSNumber numberWithFloat:def];
    NSNumber *rsNum = [self parseValue:dict key:key defValue:defNum];
    return rsNum.floatValue;
}


+ (double)optDouble:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(double)def {
    NSNumber *defNum = [NSNumber numberWithDouble:def];
    NSNumber *rsNum = [self parseValue:dict key:key defValue:defNum];
    return rsNum.doubleValue;
}


+ (long)optLong:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(long)def {
    NSNumber *defNum = [NSNumber numberWithLong:def];
    NSNumber *rsNum = [self parseValue:dict key:key defValue:defNum];
    return rsNum.longValue;
}

@end
