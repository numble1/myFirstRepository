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
@interface bookmarkBean : baseBean<NSCoding>
@property (unsafe_unretained,nonatomic)beanStyle style;
@property(nonatomic,strong)NSString *iconStr;
-(id)initWithUrlStr:(NSString*)str icon:(NSString*)iconUrlStr title:(NSString*)title;

@end
