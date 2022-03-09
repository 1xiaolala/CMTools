//
//  Utiles.h
//  AppDesign
//
//  Created by pg on 16/12/19.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/stat.h>//获取硬件型号信息
#import <AudioToolbox/AudioToolbox.h>

@interface Utiles : NSObject

// 获取应用缓存
+(CGFloat)fileSizeAtNSCache;

// 清缓存
+ (void)clearCachesWithBlock:(void (^)())completionHandler;

// md5加密
+ (NSString *)md5:(NSString *)str;

// 判断是否是iphonex系列
+ (BOOL)isIPhoneXSeries;

// 正则判断(字母和数字组合)
+ (BOOL)checkPassword:(NSString *)txt;
@end
