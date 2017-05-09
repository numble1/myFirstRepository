//
//  bookmarkBean.h
//  browser
//
//  Created by pathfinder on 2017/5/4.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "baseBean.h"
typedef NS_ENUM(NSInteger, beanStyle) {
    webViewStyle = 0,
    mainStyle,
    commonUserStyle
};
@interface bookmarkBean : baseBean
@property (unsafe_unretained,nonatomic)beanStyle style;
@end
