//
//  baseBean.h
//  browser
//
//  Created by pathfinder on 2017/4/24.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baseBean : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *uuid;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)configFiled:(NSDictionary *)dict;
@end
