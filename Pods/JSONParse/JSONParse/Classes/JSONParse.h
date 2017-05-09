//
//  JSONParse.h
//  Pods
//
//  Created by yunfenghan Ling on 3/2/17.
//
//

#import <Foundation/Foundation.h>

@interface JSONParse : NSObject

+ (BOOL)objIsNull:(id)obj;

+ (NSDictionary *)stringToNSDictionary:(NSString *)jsonString;
+ (NSDictionary *)stringToNSDictionary:(NSString *)jsonString defValue:(NSDictionary *)def;

+ (NSString *)dictToNSString:(NSDictionary *)dict;
+ (NSString *)dictToNSString:(NSDictionary *)dict defValue:(NSString *)def;



+ (NSString *)optString:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (NSString *)optString:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSString *)def;


+ (NSDictionary *)optNSDictionary:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (NSDictionary *)optNSDictionary:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSDictionary *)def;


+ (NSArray *)optNSArray:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (NSArray *)optNSArray:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSArray *)def;

+ (NSNumber *)optNSNumber:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (NSNumber *)optNSNumber:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(NSNumber *)def;



+ (BOOL)optBOOL:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (BOOL)optBOOL:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(BOOL)def;


+ (Boolean)optBoolean:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (Boolean)optBoolean:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(Boolean)def;

+ (int)optInt:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (int)optInt:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(int)def;

+ (float)optFloat:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (float)optFloat:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(float)def;

+ (double)optDouble:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (double)optDouble:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(double)def;

+ (long)optLong:(NSDictionary *)dict valueForKey:(NSString *)key;
+ (long)optLong:(NSDictionary *)dict valueForKey:(NSString *)key defValue:(long)def;


@end
