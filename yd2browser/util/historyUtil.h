//
//  historyUtil.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/11.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "historyBean.h"

@interface historyUtil : NSObject
+(void)addHistory:(historyBean *)bookMarkBean;
+(void)removewHistoryAtIndex:(NSInteger)index;
+(void)removewHistory:(historyBean *)bean;
+(void)removewAllHistory;
+(NSMutableArray*)getHistory;
@end
