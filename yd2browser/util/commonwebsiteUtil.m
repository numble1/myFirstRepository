//
//  commonwebsiteUtil.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/15.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "commonwebsiteUtil.h"

@implementation commonwebsiteUtil
+(NSArray*)getCommonWebsite{
    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:COMMONWEBSITE];
    if (!arr) {
        arr=[NSMutableArray array];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:COMMONWEBSITE];
        return arr;
    }
    return  [self sortWith:arr];
}
+(void)addCommonWebSite:(NSDictionary*)dic{
    NSArray *arr = [self getCommonWebsite];
    for (NSDictionary *sortDic in arr) {
        //websiteID表示域名 用域名来判断是否是同一网站
        NSString *str = sortDic[@"websiteId"];
        if ([str isEqualToString:dic[@"websiteId"]]) {
            NSInteger num = [sortDic[@"count"] integerValue];
            num++;
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:sortDic];
            [mutDic setValue:@(num) forKey:@"count"];
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
            [mutArr removeObject:sortDic];
            [mutArr addObject:mutDic];
            [[NSUserDefaults standardUserDefaults]setObject:mutArr forKey:COMMONWEBSITE];
            return;
        }
    }
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
    [mutArr addObject:dic];
    [[NSUserDefaults standardUserDefaults]setObject:mutArr forKey:COMMONWEBSITE];
}
+(void)removeWebsite:(NSDictionary*)dic{
    NSArray *arr = [self getCommonWebsite];
    for (NSDictionary *sortDic in arr) {
        //websiteID表示域名 用域名来判断是否是同一网站
        NSString *str = sortDic[@"websiteId"];
        if ([str isEqualToString:dic[@"websiteId"]]) {
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
            [mutArr removeObject:sortDic];
             [[NSUserDefaults standardUserDefaults]setObject:mutArr forKey:COMMONWEBSITE];
        }
    }
}
+(NSArray*)sortWith:(NSArray*)arr{
    NSArray *result = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
        NSDictionary *dic1 = (NSDictionary*)obj1;
        NSDictionary *dic2 = (NSDictionary*)obj2;
        NSNumber *num1 = [dic1 objectForKey:@"count"];
        NSNumber *num2 = [dic2 objectForKey:@"count"];
        return [num2 compare:num1]; //降序
    }];
    NSLog(@"result=%@",result);
    return result;
}


@end
