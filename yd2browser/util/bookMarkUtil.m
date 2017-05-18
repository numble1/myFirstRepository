//
//  bookMarkUtil.m
//  yd2browser
//
//  Created by pathfinder on 2017/5/11.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import "bookMarkUtil.h"

@implementation bookMarkUtil
#pragma mark editbookmark
+(void)addbookMarkBean:(bookmarkBean *)bookMarkBean{
    NSMutableArray *arr = [bookMarkUtil getBookMark];
    [arr insertObject:bookMarkBean atIndex:0];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:BOOKMARKS];
}
+(void)removewMarkBeanAtIndex:(NSInteger)index{
    NSMutableArray *arr = [bookMarkUtil getBookMark];
    [arr removeObjectAtIndex:index];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:BOOKMARKS];
}
+(void)removewMarkBean:(bookmarkBean*)bean{
    NSMutableArray *arr =[NSMutableArray arrayWithArray: [bookMarkUtil getBookMark]];
    [arr removeObject:bean];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:BOOKMARKS];

}
+(void)removewMarkBeanWith:(NSArray*)indexPathArr{
    NSMutableArray *arr =[NSMutableArray arrayWithArray:[bookMarkUtil getBookMark]];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i =0; i<indexPathArr.count ; i++) {
        NSIndexPath *path = indexPathArr[i];
        [tempArr addObject:arr[path.row]];
    }
    [arr removeObjectsInArray:tempArr];
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:BOOKMARKS];

}
+(NSMutableArray*)getBookMark{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:BOOKMARKS];
    if (!data) {
        NSMutableArray *mutArr = [NSMutableArray array];
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:mutArr];
        [[NSUserDefaults standardUserDefaults]setObject:tempArchive forKey:BOOKMARKS];
        return mutArr;
    }
    NSArray *aarr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:aarr];
    return arr;
}
@end
