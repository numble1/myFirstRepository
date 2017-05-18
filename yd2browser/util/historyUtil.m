//
//  historyUtil.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/11.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "historyUtil.h"

@implementation historyUtil

+(void)addHistory:(historyBean *)bean{
    NSMutableArray *arr = [historyUtil getHistory];
    [arr insertObject:bean atIndex:0];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:HISTORY];
}
+(void)removewAllHistory{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]];
     [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:HISTORY];
}
+(void)removewHistoryAtIndex:(NSInteger)index{
    NSMutableArray *arr =  [historyUtil getHistory];
    [arr removeObjectAtIndex:index];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:HISTORY];
}
+(void)removewHistory:(historyBean*)bean{
    NSMutableArray *arr =  [historyUtil getHistory];
    [arr removeObject:bean];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:HISTORY];
}
+(NSMutableArray*)getHistory{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:HISTORY];
    if (!data) {
        NSMutableArray *mutArr = [NSMutableArray array];
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:mutArr];
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:HISTORY];
        return mutArr;
    }
    NSArray *aarr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:aarr];
    return arr;
}
@end
