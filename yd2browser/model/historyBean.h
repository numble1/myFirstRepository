//
//  historyBean.h
//  yd2browser
//
//  Created by pathfinder on 2017/5/11.
//  Copyright © 2017年 lingyfh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historyBean : baseBean<NSCoding>
@property(nonatomic,strong)NSString *iconStr;
//@property(nonatomic,strong)NSString *mainUrl;
-(id)initWithUrlStr:(NSString*)str icon:(NSString*)iconUrlStr title:(NSString*)title;
@end
