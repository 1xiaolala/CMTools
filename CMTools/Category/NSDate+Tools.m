//
//  NSDate+Tools.m
//  Game1537
//
//  Created by apple on 2020/12/11.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

+ (NSDate *)getTimeAfterNowWithDay:(int)day
{
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    
    if(day!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*day ];

    }
    else
    {
        theDate = nowDate;
    }
    return theDate;
}
+ (NSString *)chageDateToString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+ (NSString *)chageDateToString:(NSDate *)date withFormatter:(NSString *)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = type?:@"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+ (NSString *)weekdayStringWithDate:(NSDate *)date {
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];//1代表星期日，2代表星期一，后面依次
    NSArray *weekArray = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *weekStr = weekArray[weekday-1];
    return weekStr;
}
@end
