//
//  iOSNativeShare.h
//  batteryDoctor
//
//  Created by pathfinder on 2017/3/31.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iOSNativeShare : NSObject
+ (void) shareImage: (NSString*) path Text : ( NSString*) text;
+ (void) shareText: (NSString *) text;
@end
