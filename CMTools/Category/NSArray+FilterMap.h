//
//  NSArray+FilterMap.h
//  Lottery
//
//  Created by tony on 02/01/2019.
//  Copyright © 2019 shine. All rights reserved.
//

#import <Foundation/Foundation.h>
// 重新组合的block
typedef id(^TrendMapBlock)(id obj);
typedef BOOL(^TrendSortBlock)(id obj1,id obj2);

@protocol TrendEqualProtocol <NSObject>
- (BOOL)trend_equalToObj:(id)obj;
@end

@interface NSArray (FilterMap)
#pragma mark - 数组过滤
/**
 数组过滤
 返回是否要包含，返回YES要保留，返回NO不保留
 @param filterBlock 过滤回调block
 @return 筛选过的新数组
 */
- (NSArray *)trend_filter:(BOOL(^)(id obj))filterBlock;
- (NSArray *)trend_findArrayWithObj:(id)findObj;
- (NSInteger)trend_findCountWithObj:(id)findObj;
- (BOOL)trend_isExistObj:(id)findObj;
#pragma mark 数组转换
/**
 数组转换
 将原始数组里的每一个元素转换成一个新的元素
 @param mapBlock 转换的block
 @return 转换好的数组
 */
- (NSArray *)trend_map:(TrendMapBlock)mapBlock;

/**
 将以前是包含字典的数组变成可变字典的可变数组
 Array<Dict>->MutalbalrArray<NSMutableDict>
 @return 可变字典的可变数组
 */
- (NSMutableArray *)trend_mapDictMArray;
#pragma mark 找数组内最大的值
/**
 在数组的指定范围内找最大的一个对象

 @param range 在数组的范围内
 @param maxBlock 比较block
 @return 返回找到的值
 */
- (id)trend_findMaxInRange:(NSRange)range block:(BOOL(^)(id obj1,id obj2))maxBlock;

/**
 晒选字典数组，一某个key的integerValue进行排序

 @param range 要筛选的范围
 @param key 进行判断的key
 @return 筛选完成后的内容
 */
- (id)trend_findMaxInRange:(NSRange)range key:(NSString *)key;

/**
 当前数组的转换成json字符串后是否和另一个数组转换成json数组后相等

 @param array 需要比较的数组
 @return 是否相等
 */
- (BOOL)trend_isJsonEqualToArray:(NSArray *)array;
#pragma mark 创建有默认数据的数组
/**
 创建一个有填充内容的数组
 创建指定长度，并给每个位置都设置默认数据的数组
 @param count 数组长度
 @param fillBlock 填充默认数据的回调
 @return 创建好的数组
 */
+ (NSMutableArray *)trend_fillCount:(NSInteger)count fillBlock:(id(^)(NSInteger index))fillBlock;
+ (NSMutableArray *)trend_fillCount:(NSInteger)count fillObj:obj;
#pragma mark - 创建一个数字数组
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to;
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo;
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo tailArray:(NSArray *)tailArray;
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo prefix:(NSString *)prefix suffix:(NSString *)suffix;
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo prefix:(NSString *)prefix suffix:(NSString *)suffix tailArray:(NSArray *)tailArray;
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo suffix:(NSString *)suffix prefixArray:(NSArray *)prefixArray;
+ (NSMutableArray *)trend_addArray:(NSArray *)array;
- (NSMutableArray *)trend_insertArray:(NSArray *)array atIndex:(NSInteger)index;
#pragma mark - 判断素组是否包含只能内容
/**
 判断数组是否包含一格文本
 @param txt 需要比较包含的文本
 @param ignoreZero 是否忽略无意义的0
 @return 比较结果
 */
- (BOOL)trend_isContainsTxt:(NSString *)txt ignoreZero:(BOOL)ignoreZero;
/**
 找到数组中和当前文本一样的内容(忽略无意义的0)
 @param txt 需要比较包含的文本
 @return 找到的包含的内容
 */
- (NSString *)trend_findContainsTxt:(NSString *)txt;
#pragma mark 获取数组包含指定内容的数量
/**
 数组包含某个字符串的个数

 @param txt 需要比较的个数
 @param ignoreZero 是否忽略无意义的0
 @return 包含的个数
 */
- (NSInteger)trend_containsCountWithTxt:(NSString *)txt ignoreZero:(BOOL)ignoreZero;
#pragma mark - 截取指定范围的数据
/**
 从一个数组里截取一个子数组，如果需要截取的长度大于数据的长度，以数据长度为准

 @param range 要截取的位置
 @return 截取后返回的数组
 */
- (NSArray *)trend_subArrayWithRange:(NSRange)range;
- (NSArray *)trend_subArrayFromIndex:(NSInteger)index;
- (NSArray *)trend_subArrayToIndex:(NSInteger)index;
#pragma mark - 将数组组装成一个属性字符串
- (NSAttributedString *)trend_attrTxtWithColor:(UIColor *)color range:(NSRange)range seperator:(NSString *)seperator;
- (NSAttributedString *)trend_attrTxtWithColor:(UIColor *)color redRange:(NSRange)redRange redColor:(UIColor *)redColor seperator:(NSString *)seperator;
#pragma mark - 转换组三组六
- (NSString *)trend_transferThreeToGroupTxt;
- (NSArray *)trend_subRange:(NSRange)range;
- (NSDictionary *)trend_findInt:(NSInteger)val key:(NSString *)key;
- (NSDictionary *)trend_findString:(NSString *)val key:(NSString *)key;

- (void)trend_archiveWithKey:(NSString *)key;
- (void)trend_archiveWithClass:(Class)clazz key:(NSString *)key;
+ (NSArray *)trend_unArchiveWithKey:(NSString *)key;
+ (NSArray *)trend_unArchiveWithClass:(Class)clazz key:(NSString *)key;
#pragma mark - 数组排序
// 对数组里的内容进行排序，默认升序
- (NSArray *)trend_sort;
- (NSArray *)trend_sortWithAscending:(BOOL)ascending;
- (NSArray *)trend_sortAsNumber;
- (NSArray *)trend_sortAsNumberWithKey:(NSString *)key;
- (NSArray *)trend_sortAsNumberWithKey:(NSString *)key ascending:(BOOL)ascending;
// 以key进行升序排序，默认升序
- (NSArray *)trend_sortWithKey:(NSString *)key;
- (NSArray *)trend_sortWithKey:(NSString *)key ascending:(BOOL)ascending;
- (NSArray *)trend_sortWithBlock:(TrendSortBlock)block;
- (BOOL)trend_equalTo:(NSArray *)list;
@end
#pragma mark -
@interface NSMutableArray (Trend)
- (void)trend_fillCount:(NSInteger)count fillBlock:(id(^)(NSInteger index))fillBlock;
- (void)trend_fillCount:(NSInteger)count fillObj:obj;
@end
#pragma mark -
@interface NSDictionary (Trend)
- (NSString *)trend_parse2JsonTxt;
@end

#pragma mark -
@interface NSString (TrendNumber)
- (BOOL)trend_isNumberTxt;
@end
#pragma mark -
@interface NSMutableDictionary (Combine)
- (void)trend_combineDict:(NSDictionary *)dict;
@end
