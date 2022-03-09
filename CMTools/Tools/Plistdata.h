//
//  SaveLocaldata.h
//  AppDesign
//
//  Created by pg on 16/12/13.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plistdata : NSObject

+(BOOL)saveData:(id)data toPlist:(NSString *)fileName;

+(id)getPlistDataFrom:(NSString *)fileName andType:(NSString *)type;

+(BOOL)clearPlist:(NSString *)fileName;

+ (void)saveToUserDefalut:(id)obj fromKey:(NSString *)key;

+ (id)getFromUserDefalutKey:(NSString *)key;
@end
