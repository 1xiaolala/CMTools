//
//  NSString+Tools.m
//  EBuy
//
//  Created by mac on 2020/10/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

+ (BOOL)isBlankString:(NSString *)aStr{
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString *)changeToMonth:(NSString *)timeStr{
    NSString *dateTimeStr = [self timeWithTimeIntervalString:timeStr];
    dateTimeStr = [dateTimeStr substringFromIndex:5];
    dateTimeStr = [dateTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    dateTimeStr = [dateTimeStr stringByAppendingString:@"日"];
    return dateTimeStr;
}
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
+ (NSMutableAttributedString *)attributedStringWith:(NSString *)content withChar:(NSString *)charStr withColor:(UIColor *)color withFont:(CGFloat)font
{
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:content];
    //找出特定字符在整个字符串中的位置
    
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:((charStr.length > 0 )? charStr : @"")].location, [[contentStr string] rangeOfString:charStr].length);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:redRange];
    return contentStr;
}
+ (NSMutableAttributedString *)attributedStringWith:(NSString *)content withChar:(NSString *)charStr withChar2:(NSString *)charStr2 withChar3:(NSString *)charStr3 withColor:(UIColor *)color withColor2:(UIColor *)color2 withFont:(CGFloat)font{
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:content];
    //找出特定字符在整个字符串中的位置
    if ([NSString isBlankString:charStr]) charStr = @"";
    if ([NSString isBlankString:charStr2]) charStr2 = @"";
    if ([NSString isBlankString:charStr3]) charStr3 = @"";

    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:charStr].location, [[contentStr string] rangeOfString:charStr].length);
    NSRange redRange2 = NSMakeRange([[contentStr string] rangeOfString:charStr2].location, [[contentStr string] rangeOfString:charStr2].length);
    NSRange redRange3 = NSMakeRange([[contentStr string] rangeOfString:charStr3].location, [[contentStr string] rangeOfString:charStr3].length);
    //修改特定字符的颜色
    if (color) {
        [contentStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    }
    if (![NSString isBlankString:charStr2]) {
        [contentStr addAttribute:NSForegroundColorAttributeName value:color2 range:redRange2];
    }
    if (![NSString isBlankString:charStr3]) {
        [contentStr addAttribute:NSForegroundColorAttributeName value:color2 range:redRange3];
    }
    
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:redRange];
    if (![NSString isBlankString:charStr2]) {
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:redRange2];
    }
    if (![NSString isBlankString:charStr3]) {
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:redRange3];
    }
    return contentStr;
}
+ (NSString *)encodingStrWithChar:(NSString *)str{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *token = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return token;
}
- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}
+ (BOOL)judgeStrEqualStrWithData:(NSString *)jsonStr{
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSArray *arr = [jsonStr componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *number in arr) {
        [dic setObject:number forKey:number];
    }
    NSArray *newArray = [dic allKeys];
    if (arr.count != newArray.count) {
        return YES;
    }
    return NO;
}
+ (NSString *)removeFloatAllZero:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}
+ (NSString *)getVersion{
    return [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}
+ (NSString *)textFromBase64String:(NSString *)base64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
}
+ (BOOL)isLinkUrl:(NSString *)linkStr
{
    NSString*emailRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@",emailRegex];
    return [predicate evaluateWithObject:linkStr];
}
+ (BOOL)isPureNumandCharacters:(NSString *)string{
    for(int i=0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
+ (NSString *)getTimeStringFormatter:(long)stringTime
{
    if (!stringTime) {
        return @"";
    }
    stringTime = stringTime/1000;
    // 最后一次的时间要改成 凌晨 昨天下午 周一 10月1日 月日时间 年月日时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月"];
    NSString *mmStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:stringTime]];
    [formatter setDateFormat:@"dd日"];
    NSString *dayStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:stringTime]];
    [formatter setDateFormat:@"HH"];
    int timeHour =
    [[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:stringTime]] intValue];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeDetail =
    [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:stringTime]];
    NSString *stringShow;
    if (timeHour < 6) {
        stringShow = [NSString stringWithFormat:@"%@%@ 凌晨 %@",mmStr,dayStr, timeDetail];
    } else if (timeHour >= 6 && timeHour < 12) {
        stringShow = [NSString stringWithFormat:@"%@%@ 上午 %@",mmStr,dayStr, timeDetail];
    } else if (timeHour >= 12 && timeHour < 18) {
        stringShow = [NSString stringWithFormat:@"%@%@下午 %@",mmStr,dayStr, timeDetail];
    } else {
        stringShow = [NSString stringWithFormat:@"%@%@ 晚上 %@",mmStr,dayStr, timeDetail];
    }
    return stringShow;
}
+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
+ (NSString*)getTheCorrectNum:(NSString*)tempString{
    //计算截取的长度
    NSUInteger endLength = tempString.length;
    //判断字符串是否包含 .
    if ([tempString containsString:@"."]) {
        //取得 . 的位置
        NSRange pointRange = [tempString rangeOfString:@"."];
        NSLog(@"%lu",pointRange.location);
        //判断 . 后面有几位
        NSUInteger f = tempString.length - 1 - pointRange.location;
        //如果大于2位就截取字符串保留两位,如果小于两位,直接截取
        if (f > 2) {
            endLength = pointRange.location + 2;
        }
    }
    //先将tempString转换成char型数组
    NSUInteger start = 0;
    const char *tempChar = [tempString UTF8String];
    //遍历,去除取得第一位不是0的位置
    for (int i = 0; i < tempString.length; i++) {
        if (tempChar[i] == '0') {
            start++;
        }else {
            break;
        }
    }
    //根据最终的开始位置,计算长度,并截取
    NSRange range = {start,endLength-start};
    tempString = [tempString substringWithRange:range];
    return tempString;
}
+ (NSString *)getShengXiaowithYear:(NSString *)year {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *thisYearString=[dateformatter stringFromDate:senddate];
    if ([NSString isBlankString:year]) {
        year = thisYearString;
    }
    NSArray *chineseYears = [NSArray arrayWithObjects:@"甲子",@"乙丑",@"丙寅",@"丁卯",@"戊辰",@"己巳",@"庚午",@"辛未",@"壬申",@"癸酉",@"甲戌",@"乙亥",@"丙子",@"丁丑",@"戊寅",@"己卯",@"庚辰",@"辛己",@"壬午",@"癸未",@"甲申",@"乙酉",@"丙戌",@"丁亥",@"戊子",@"己丑",@"庚寅",@"辛卯",@"壬辰",@"癸巳",@"甲午",@"乙未",@"丙申",@"丁酉",@"戊戌",@"己亥",@"庚子",@"辛丑",@"壬寅",@"癸丑",@"甲辰",@"乙巳",@"丙午",@"丁未",@"戊申",@"己酉",@"庚戌",@"辛亥",@"壬子",@"癸丑",@"甲寅",@"乙卯",@"丙辰",@"丁巳",@"戊午",@"己未",@"庚申",@"辛酉",@"壬戌",@"癸亥", nil];
    NSArray *chineseMonths=[NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *chineseDays=[NSArray arrayWithObjects:@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五", @"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    NSDate *dateTemp =nil;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    dateTemp = [dateFormater dateFromString:year];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    NSString*y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString*m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString*d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString*Cz_str =nil;
    if([y_str hasSuffix:@"子"]) {
        Cz_str =@"鼠";
    }else if([y_str hasSuffix:@"丑"]){
        Cz_str =@"牛";
    }else if([y_str hasSuffix:@"寅"]){
        Cz_str =@"虎";
    }else if([y_str hasSuffix:@"卯"]){
        Cz_str =@"兔";
    }else if([y_str hasSuffix:@"辰"]){
        Cz_str =@"龙";
    }else if([y_str hasSuffix:@"巳"]){
        Cz_str =@"蛇";
    }else if([y_str hasSuffix:@"午"]){
        Cz_str =@"马";
    }else if([y_str hasSuffix:@"未"]){
        Cz_str =@"羊";
    }else if([y_str hasSuffix:@"申"]){
        Cz_str =@"猴";
    }else if([y_str hasSuffix:@"酉"]){
        Cz_str =@"鸡";
        
    }else if([y_str hasSuffix:@"戌"]){
        Cz_str =@"狗";
        
    }else if([y_str hasSuffix:@"亥"]){
        Cz_str =@"猪";
        
    }
    return Cz_str;
}
+ (NSArray *)getShengXiaoOrder{
    NSArray *arr = @[];
    NSString *shengxiao = [NSString getShengXiaowithYear:@""];
    if ([shengxiao isEqualToString:@"鼠"]) {
        arr = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
    } else if ([shengxiao isEqualToString:@"牛"]) {
        arr = @[@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠"];
    } else if ([shengxiao isEqualToString:@"虎"]) {
        arr = @[@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛"];
    } else if ([shengxiao isEqualToString:@"兔"]) {
        arr = @[@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎"];
    } else if ([shengxiao isEqualToString:@"龙"]) {
        arr = @[@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔"];
    } else if ([shengxiao isEqualToString:@"蛇"]) {
        arr = @[@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙"];
    } else if ([shengxiao isEqualToString:@"马"]) {
        arr = @[@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇"];
    } else if ([shengxiao isEqualToString:@"羊"]) {
        arr = @[@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马"];
    } else if ([shengxiao isEqualToString:@"猴"]) {
        arr = @[@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊"];
    } else if ([shengxiao isEqualToString:@"鸡"]) {
        arr = @[@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴"];
    } else if ([shengxiao isEqualToString:@"狗"]) {
        arr = @[@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡"];
    } else if ([shengxiao isEqualToString:@"猪"]) {
        arr = @[@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗"];
    }
    return arr;
}
+ (NSString *)transformPinYinWithString:(NSString *)chinese{
    NSString  * pinYinStr = [NSString string];
    if (chinese.length){
        NSMutableString * pinYin = [[NSMutableString alloc]initWithString:chinese];
        //1.先转换为带声调的拼音
        if(CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO)) {}
        //2.再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO)) {}
        //3.去除掉首尾的空白字符和换行字符
        pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //4.去除掉其它位置的空白字符和换行字符
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        [pinYinStr capitalizedString];
    }
    return pinYinStr;
}

@end
