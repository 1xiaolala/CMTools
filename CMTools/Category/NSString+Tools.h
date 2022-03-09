//
//  NSString+Tools.h
//  EBuy
//
//  Created by mac on 2020/10/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

/**
 判断字符串是否为空

 */
+ (BOOL)isBlankString:(NSString *)aStr;
// 时间戳转时间格式字符串
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
+ (NSString *)changeToMonth:(NSString *)timeStr;
//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data;
/**
 更改字符串特定字符颜色

 @param content 字符串
 @param charStr 需要变化的字符
 @param color 颜色
 @param font 字体大小
 */
+ (NSMutableAttributedString *)attributedStringWith:(NSString *)content withChar:(NSString *)charStr withColor:(UIColor *)color withFont:(CGFloat)font;
+ (NSMutableAttributedString *)attributedStringWith:(NSString *)content withChar:(NSString *)charStr withChar2:(NSString *)charStr2 withChar3:(NSString *)charStr3 withColor:(UIColor *)color withColor2:(UIColor *)color2 withFont:(CGFloat)font;
// 字符串编码
+ (NSString *)encodingStrWithChar:(NSString *)str;
// 计算字符串高度
- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;
// 判断字符串是否包含相同的char
+ (BOOL)judgeStrEqualStrWithData:(NSString *)jsonStr;
// 移除字符串后面多余的0
+ (NSString *)removeFloatAllZero:(NSString *)string;
// 获取版本号
+ (NSString *)getVersion;
// base64转普通文本
+ (NSString *)textFromBase64String:(NSString *)base64;
// 是否是链接
+ (BOOL)isLinkUrl:(NSString * )linkStr;
// 判断字符串是否有中文
+ (BOOL)isPureNumandCharacters:(NSString *)string;
+ (NSString *)getTimeStringFormatter:(long)stringTime;
+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;
// 截取小数点后2位
+ (NSString*)getTheCorrectNum:(NSString*)tempString;

/// 根据年份判断生肖
/// @param year 年
+ (NSString *)getShengXiaowithYear:(NSString *)year;

/// 获取生肖排序
+ (NSArray *)getShengXiaoOrder;
  
// 汉字转拼音
+ (NSString *)transformPinYinWithString:(NSString *)chinese;
@end
