//
//  bookMarkUtil.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/11.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookmarkBean.h"

@interface bookMarkUtil : NSObject
+(void)addbookMarkBean:(bookmarkBean *)bookMarkBean;
+(void)removewMarkBeanAtIndex:(NSInteger)index;
+(void)removewMarkBean:(bookmarkBean*)bean;
+(NSMutableArray*)getBookMark;
+(void)removewMarkBeanWith:(NSArray*)indexPathArr;
@end
