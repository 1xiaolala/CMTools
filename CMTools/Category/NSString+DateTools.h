//
//  NSString+DateTools.h
//  EBuy
//
//  Created by apple on 2020/10/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DateTools)

+ (NSString *)changeDateToDateString:(NSDate *)date;
// 转换时间格式
+(NSString *)changeTime:(NSString *)string;
// 返回当前时间的时间戳
+ (NSString *)getCurrentDateStamp;
// 时间字符串转时间戳
+ (NSString *)getDateChangeString:(NSString *)str withFormat:(NSString *)formatter;
// 比较2个时间戳差值
+ (long) getCompareWithBegainTime:(long)begainTime andEndTime:(long)endTime;
//字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;
//时间戳变为格式时间
+ (NSString *)convertStrToTime:(NSString *)timeStr;
+ (NSString *)convertStrToTime:(NSString *)timeStr withFormat:(NSString *)format;
@end

NS_ASSUME_NONNULL_END
