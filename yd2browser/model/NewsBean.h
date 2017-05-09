//
//  WallpaperBean.h
//  yd2xinwen
//
//  Created by Lacuna on 16/6/7.
//  Copyright © 2016年 f. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseBean.h"

@interface NewsBean : baseBean <NSCoding>
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *desc;
@property (retain, nonatomic) NSString *time;
@property (retain, nonatomic) NSString *detail_link;
@property (retain, nonatomic) NSString *src;
@property (retain, nonatomic) NSString *icon;
@property (retain, nonatomic) NSArray *category;


@end
