//
//  NSString+DateTools.m
//  EBuy
//
//  Created by apple on 2020/10/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NSString+DateTools.h"

@implementation NSString (DateTools)

+ (NSString *)changeDateToDateString:(NSDate *)date{
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr1 = [dateFmt stringFromDate:date];
    return dateStr1;
}

+ (NSString *)changeTime:(NSString *)string{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    if (string.length==14) {
        [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    }else{
        if (string.length==8) {
            [inputFormatter setDateFormat:@"yyyyMMdd"];
        }else{
            [inputFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        }
        
    }
    NSDate *inputDate =[[NSDate alloc]init];
    [inputFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    inputDate=[inputFormatter dateFromString:string];
    //    NSString *lString = [inputFormatter stringFromDate:inputDate];
    //第二次时间转换
    NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str1 = [df2 stringFromDate:inputDate];
    
    return str1;
}
//返回当前时间的时间戳
+ (NSString *)getCurrentDateStamp
{
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
+ (NSString *)getDateChangeString:(NSString *)str withFormat:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:formatter?:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
+ (long) getCompareWithBegainTime:(long)begainTime andEndTime:(long)endTime
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:begainTime];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSCalendar *gregorian = [[ NSCalendar alloc ] initWithCalendarIdentifier : NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
//    NSInteger years = [components year];
//    NSInteger months = [components month];
//    NSInteger days = [components day];
//    NSInteger hour = [components hour];
//    NSInteger minute = [components minute];
    long second = [components second];
    return  second;
}
//字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}
+ (NSString *)convertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue]/1000;
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}
+ (NSString *)convertStrToTime:(NSString *)timeStr withFormat:(NSString *)format
{
    long long time=[timeStr longLongValue]/1000;
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format?:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString=[formatter stringFromDate:date];
    return timeString;
}
@end
