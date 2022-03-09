//
//  NSDate+Tools.h
//  Game1537
//
//  Created by apple on 2020/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Tools)

/**
 得到当前时间N天前后的日期
 @param day   传入正数 n天后   传入负数 N天前
 @return return value description
 */
+ (NSDate *)getTimeAfterNowWithDay:(int)day;
// 时间转时间字符串
+ (NSString *)chageDateToString:(NSDate *)date;
// 时间转时间字符串（转自定义格式）
+ (NSString *)chageDateToString:(NSDate *)date withFormatter:(NSString *)type;
// 判断星期几
+ (NSString *)weekdayStringWithDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
