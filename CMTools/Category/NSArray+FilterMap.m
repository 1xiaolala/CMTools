//
//  NSArray+FilterMap.m
//  Lottery
//
//  Created by tony on 02/01/2019.
//  Copyright © 2019 shine. All rights reserved.
//

#import "NSArray+FilterMap.h"
#import "NSString+Tools.h"

@implementation NSArray (FilterMap)
#pragma mark - 数组过滤
/**
 数组过滤
 返回是否要包含，返回YES要保留，返回NO不保留
 @param filterBlock 过滤回调block
 @return 筛选过的新数组
 */
- (NSArray *)trend_filter:(BOOL (^)(id obj))filterBlock
{
    if (filterBlock == nil) {
        return self;
    }
    // 过滤
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (filterBlock(obj)) {
            [arrayM addObject:obj];
        }
        
    }];
    // 将可变数组转换为不可变数组
    return [NSArray arrayWithArray:arrayM];

}
- (NSArray *)trend_findArrayWithObj:(id)findObj
{
    NSArray *findList = [self trend_filter:^BOOL(id obj) {
        if([findObj isKindOfClass:[NSString class]]){
            return [(NSString *)findObj isEqualToString:obj];
        }
        return findObj == obj;
    }];
    return findList;
}
- (NSInteger)trend_findCountWithObj:(id)findObj
{
    NSArray *findList = [self trend_findArrayWithObj:findObj];
    return findList.count;
}
- (BOOL)trend_isExistObj:(id)findObj
{
    return ([self indexOfObject:findObj] != NSNotFound);
}
#pragma mark 数组转换
/**
 数组转换
 将原始数组里的每一个元素转换成一个新的元素
 @param mapBlock 转换的block
 @return 转换好的数组
 */
- (NSArray *)trend_map:(TrendMapBlock)mapBlock
{
    if (mapBlock == nil) {
        return self;
    }
    // 转换
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayM addObject:mapBlock(obj)];
    }];
    // 将可变数组转换为不可变数组
    return arrayM;
}
/**
 将以前是包含字典的数组变成可变字典的可变数组
 Array<Dict>->MutalbalrArray<NSMutableDict>
 @return 可变字典的可变数组
 */
- (NSMutableArray *)trend_mapDictMArray
{
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [arrayM addObject:[NSMutableDictionary dictionaryWithDictionary:obj]];
        }else{
            [arrayM addObject:obj];
        }
    }];
    return arrayM;
}
- (id)trend_findMaxInRange:(NSRange)range block:(BOOL(^)(id obj1,id obj2))maxBlock;
{
    NSArray *array = [self trend_subArrayWithRange:range];
    if (array.count == 0) {
        return nil;
    }
    id obj1 = array.firstObject;
    if (maxBlock) {
        for(NSInteger i=1;i<array.count;i++){
            id obj2 = array[i];
            if (maxBlock(obj1,obj2)) {
                obj1 = obj2;
            }
        }
    }
    return obj1;
}
/**
 晒选字典数组，一某个key的integerValue进行排序
 
 @param range 要筛选的范围
 @param key 进行判断的key
 @return 筛选完成后的内容
 */
- (id)trend_findMaxInRange:(NSRange)range key:(NSString *)key
{
    return [self trend_findMaxInRange:range block:^BOOL(id obj1, id obj2) {
        return [obj2[key] integerValue]>[obj1[key] integerValue];
    }];
}

/**
 当前数组的转换成json字符串后是否和另一个数组转换成json数组后相等
 
 @param array 需要比较的数组
 @return 是否相等
 */
- (BOOL)trend_isJsonEqualToArray:(NSArray *)array
{
    if (array == nil) {
        return NO;
    }
    NSError *error = nil;
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:self
                                                       options:kNilOptions
                                                         error:&error];
    if (error != nil || jsonData1 == nil) {
        return NO;
    }
    NSString *jsonString1 = [[NSString alloc] initWithData:jsonData1
                                                 encoding:NSUTF8StringEncoding];
    if (jsonString1 == nil) {
        return NO;
    }
    NSError *error2 = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:array
                                                options:kNilOptions
                                                  error:&error2];
    if (error2 != nil || jsonData2 == nil) {
        return NO;
    }
    NSString *jsonString2 = [[NSString alloc] initWithData:jsonData2
                                                  encoding:NSUTF8StringEncoding];
    return [jsonString1 isEqualToString:jsonString2];
}
#pragma mark 创建有默认数据的数组
/**
 创建一个有填充内容的数组
 创建指定长度，并给每个位置都设置默认数据的数组
 @param count 数组长度
 @param fillBlock 填充默认数据的回调
 @return 创建好的数组
 */
+ (NSMutableArray *)trend_fillCount:(NSInteger)count fillBlock:(id(^)(NSInteger index))fillBlock
{
    NSMutableArray *arrayM = [NSMutableArray array];
    if (fillBlock != nil) {
        for (NSInteger i=0; i<count; i++) {
           id obj = fillBlock(i);
            if (obj) {
                [arrayM addObject:obj];
            }else{
                // 没有传数据则默认设置NSNull
                [arrayM addObject:[[NSNull alloc] init]];
            }
        }
    }
    return arrayM;
}
+ (NSMutableArray *)trend_fillCount:(NSInteger)count fillObj:obj
{
    return [self trend_fillCount:count fillBlock:^id(NSInteger index) {
        return obj;
    }];
}
#pragma mark - 创建一个数字数组
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to
{
    return [self trend_fillNumFrom:from to:to isTwo:NO prefix:nil suffix:nil];
}
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo
{
    return [self trend_fillNumFrom:from to:to isTwo:isTwo prefix:nil suffix:nil];
}
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo prefix:(NSString *)prefix suffix:(NSString *)suffix
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for(NSInteger i=from;i<=to;i++){
        NSString *txt = nil;
        if (isTwo) {
            txt = [NSString stringWithFormat:@"%02ld",i];
        }else{
            txt = [NSString stringWithFormat:@"%ld",i];
        }
        if (prefix != nil) {
            txt = [NSString stringWithFormat:@"%@%@",prefix,txt];
        }
        if (suffix != nil) {
            txt = [NSString stringWithFormat:@"%@%@",txt,suffix];
        }
        [arrayM addObject:txt];
    }
    return arrayM;
}
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo suffix:(NSString *)suffix prefixArray:(NSArray *)prefixArray
{
    NSMutableArray *arrayM = [self trend_fillNumFrom:from to:to isTwo:isTwo prefix:nil suffix:suffix];
    [arrayM trend_insertArray:prefixArray atIndex:0];
    return arrayM;
}
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo prefix:(NSString *)prefix suffix:(NSString *)suffix tailArray:(NSArray *)tailArray
{
    NSMutableArray *arrayM = [self trend_fillNumFrom:from to:to isTwo:isTwo prefix:prefix suffix:suffix];
    if (tailArray != nil && tailArray.count>0) {
        [arrayM addObjectsFromArray:tailArray];
    }
    return arrayM;
}
+ (NSMutableArray *)trend_fillNumFrom:(NSInteger)from to:(NSInteger)to isTwo:(BOOL)isTwo tailArray:(NSArray *)tailArray
{
    return [self trend_fillNumFrom:from to:to isTwo:isTwo prefix:nil suffix:nil tailArray:tailArray];
}
- (NSMutableArray *)trend_insertArray:(NSArray *)array atIndex:(NSInteger)index
{
    NSMutableArray *arrayM = nil;
    if ([self isKindOfClass:[NSMutableArray class]]) {
        arrayM = (NSMutableArray *)self;
    }else{
        arrayM = [NSMutableArray array];
    }
    if (array != nil && array.count>0) {
        [arrayM insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, array.count)]];
    }
    return arrayM;
}

+ (NSMutableArray *)trend_addArray:(NSArray *)array
{
    NSMutableArray *arrayM = nil;
    if ([self isKindOfClass:[NSMutableArray class]]) {
        arrayM = (NSMutableArray *)self;
    }else{
        arrayM = [NSMutableArray array];
    }
    if (array != nil && array.count>0) {
        [arrayM addObjectsFromArray:array];
    }
    return arrayM;
}
#pragma mark -
/**
 判断数组是否包含一格文本
 @param txt 需要比较包含的文本
 @param ignoreZero 是否忽略无意义的0
 @return 比较结果
 */
- (BOOL)trend_isContainsTxt:(NSString *)txt ignoreZero:(BOOL)ignoreZero;
{
    if (txt == nil) {
        // 空数据则不包含
        return NO;
    }
    // 兼容字符串和number类型
    NSArray *list = [self trend_map:^id(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%ld",[obj integerValue]];
        }else{
            return obj;
        }
    }];
    NSString *findTxt = txt;
    if ([findTxt isKindOfClass:[NSNumber class]]) {
        findTxt = [NSString stringWithFormat:@"%ld",[((NSNumber *)findTxt) integerValue]];
    }
    if (ignoreZero) {
        // 去掉无意义的0
        NSString *ignoreFindTxt = findTxt;
        while (ignoreFindTxt.length>1 && [ignoreFindTxt hasPrefix:@"0"]) {
            ignoreFindTxt = [ignoreFindTxt substringFromIndex:1];
        }
        // 对数组里的数字进行去掉无意义的0
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSString *originTxt in list) {
            NSString *noZeroTxt = originTxt;
            while (noZeroTxt.length>1 && [noZeroTxt hasPrefix:@"0"]) {
                noZeroTxt = [noZeroTxt substringFromIndex:1];
            }
            [arrayM addObject:noZeroTxt];
        }
        // 如果存在则包含
        return [arrayM indexOfObject:ignoreFindTxt] != NSNotFound;
    }else{
        // 如果存在则包含
        return [list indexOfObject:findTxt] != NSNotFound;
    }
    return NO;
}
/**
 找到数组中和当前文本一样的内容(忽略无意义的0)
 @param txt 需要比较包含的文本
 @return 找到的包含的内容
 */
- (NSString *)trend_findContainsTxt:(NSString *)txt;
{
    if (txt == nil) {
        // 空数据则不包含
        return nil;
    }
    // 兼容字符串和number类型
    for(NSString *originTxt in self){
        if(txt.integerValue != 0){
            // 说明是数字
            if(txt.integerValue == originTxt.integerValue){
                return originTxt;
            }
        }else{
            // 说明不是数字的文本或者是真正的0
            // 去掉无意义的前面的0
            NSString *findTxt = txt;
            while (findTxt.length>1 && [findTxt hasPrefix:@"0"]) {
                findTxt = [findTxt substringFromIndex:1];
            }
            NSString *findOriginTxt = originTxt;
            while (findOriginTxt.length>1 && [findOriginTxt hasPrefix:@"0"]) {
                findOriginTxt = [findOriginTxt substringFromIndex:1];
            }
            if([findTxt isEqualToString:findOriginTxt]){
                return findOriginTxt;
            }
        }
    }
    return nil;
}
/**
 数组包含某个字符串的个数
 
 @param txt 需要比较的个数
 @param ignoreZero 是否忽略无意义的0
 @return 包含的个数
 */
- (NSInteger)trend_containsCountWithTxt:(NSString *)txt ignoreZero:(BOOL)ignoreZero
{
    if (txt == nil) {
        // 空数据则不包含
        return 0;
    }
    NSArray *list = [self trend_map:^id(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%ld",[obj integerValue]];
        }else{
            return obj;
        }
    }];
    NSString *findTxt = txt;
    if ([findTxt isKindOfClass:[NSNumber class]]) {
        findTxt = [NSString stringWithFormat:@"%ld",[((NSNumber *)findTxt) integerValue]];
    }
    if (ignoreZero) {
        // 去掉无意义的0
        NSString *ignoreFindTxt = findTxt;
        while (ignoreFindTxt.length>1 && [ignoreFindTxt hasPrefix:@"0"]) {
            ignoreFindTxt = [ignoreFindTxt substringFromIndex:1];
        }
        // 对数组里的数字进行去掉无意义的0
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSString *originTxt in list) {
            NSString *noZeroTxt = originTxt;
            while (noZeroTxt.length>1 && [noZeroTxt hasPrefix:@"0"]) {
                noZeroTxt = [noZeroTxt substringFromIndex:1];
            }
            [arrayM addObject:noZeroTxt];
        }
        // 筛选掉不一样的内容
        return [arrayM trend_filter:^BOOL(NSString *filterTxt) {
            return [filterTxt isEqualToString:ignoreFindTxt];
        }].count;
    }else{
        return [list trend_filter:^BOOL(NSString *filterTxt) {
            return [filterTxt isEqualToString:findTxt];
        }].count;
    }
    return 0;
}
#pragma mark -
/**
 从一个数组里截取一个子数组，如果需要截取的长度大于数据的长度，以数据长度为准
 
 @param range 要截取的位置
 @return 截取后返回的数组
 */
- (NSArray *)trend_subArrayWithRange:(NSRange)range
{
    // 没有数据，则返回空数据
    if (self.count == 0) {
        return @[];
    }
    NSInteger from = range.location;
    // 如果开始位置大于数据长度，则返回空数组
    if (from>=self.count) {
        return @[];
    }
    NSInteger to = range.location+range.length-1;
    // 如果结束位置大于数据长度，则以数据的最后一个为结束位置
    if (to>=self.count) {
        to = self.count-1;
    }
    return [self subarrayWithRange:NSMakeRange(from, to-from+1)];
}
- (NSArray *)trend_subArrayFromIndex:(NSInteger)index
{
    NSRange range = NSMakeRange(index, self.count-index);
    return [self trend_subArrayWithRange:range];
}
- (NSArray *)trend_subArrayToIndex:(NSInteger)index
{
    NSRange range = NSMakeRange(0, index+1);
    return [self trend_subArrayWithRange:range];
}
- (NSAttributedString *)trend_attrTxtWithColor:(UIColor *)color range:(NSRange)range seperator:(NSString *)seperator
{
    return [self trend_attrTxtWithColor:nil redRange:range redColor:color seperator:seperator];
}
- (NSAttributedString *)trend_attrTxtWithColor:(UIColor *)color redRange:(NSRange)redRange redColor:(UIColor *)redColor seperator:(NSString *)seperator
{
    NSArray *array = self;
    NSString *joinTxt = @"";
    NSInteger fromIndex = 0;
    NSInteger length = 0;
    for(NSInteger i=0;i<array.count;i++){
        // 计算真正的起始位置
        if (i==redRange.location) {
            fromIndex = joinTxt.length;
        }
        NSString *txt = array[i];
        if (i==0) {
            joinTxt = txt;
        }else{
            joinTxt = [NSString stringWithFormat:@"%@%@%@",joinTxt,seperator,txt];
        }
        // 计算真正的结束位置
        if (i == (redRange.location+redRange.length-1)) {
            length = joinTxt.length-fromIndex;
        }
    }
    
    NSMutableAttributedString *awardAttrTxt = [[NSMutableAttributedString alloc] initWithString:joinTxt];
    // 背景颜色
    if (color != nil) {
        [awardAttrTxt addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, joinTxt.length)];
    }
    if(redColor != nil){
        // 红色
        [awardAttrTxt addAttribute:NSForegroundColorAttributeName value:redColor range:NSMakeRange(fromIndex, length)];
    }
    return awardAttrTxt;
}
#pragma mark - 转换组三组六
- (NSString *)trend_transferThreeToGroupTxt
{
    NSArray *nums = self;
    if (nums.count>=3) {
        NSArray *lastNum3 = [nums subarrayWithRange:NSMakeRange(nums.count-3, 3)];
        NSSet *lastNumSet = [NSSet setWithArray:lastNum3];
        
        if (lastNumSet.count == 3) {
            // 0组相同，则还剩3个数字
            return @"组六";
        }
        else if (lastNumSet.count == 2) {
            // 1组相同，则还剩2个数字
            return @"组三";
        }
        else if (lastNumSet.count == 1) {
            // 3组相同，则还剩1个数字
            return @"豹子";
        }else{
            // 这种情况不会出现
            return @"";
        }
        
    }else{
        return @"";
    }
}
- (NSArray *)trend_subRange:(NSRange)range
{
    if (self.count<(range.location+range.length)) {
        if (self.count<=range.location) {
            return @[];
        }else{
            return [self subarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
        }
        
    }else{
        return [self subarrayWithRange:range];
    }
    
}
- (NSDictionary *)trend_findInt:(NSInteger)val key:(NSString *)key
{
    for(NSDictionary *dict in self){
        if(![dict isKindOfClass:[NSDictionary class]]){
            continue;
        }
        if(dict[key] == nil){
            continue;
        }
        if ([dict[key] integerValue] == val) {
            return dict;
        }
    }
    return nil;
    
}
- (NSDictionary *)trend_findString:(NSString *)val key:(NSString *)key
{
    for(NSDictionary *dict in self){
        if(![dict isKindOfClass:[NSDictionary class]]){
            continue;
        }
        if(dict[key] == nil){
            continue;
        }
        if ([dict[key] stringValue] == val) {
            return dict;
        }
    }
    return nil;
}
- (void)trend_archiveWithClass:(Class)clazz key:(NSString *)key
{
    NSString *saveKey = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(clazz),key];
    [self trend_archiveWithKey:saveKey];
}
- (void)trend_archiveWithKey:(NSString *)key
{
    NSString *saveKey = [NSString stringWithFormat:@"%@.data",key];
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:saveKey];
     [NSKeyedArchiver archiveRootObject:self toFile:file];
    
}
+ (NSArray *)trend_unArchiveWithClass:(Class)clazz key:(NSString *)key
{
    NSString *saveKey = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(clazz),key];
    return [self trend_unArchiveWithKey:saveKey];
}
+ (NSArray *)trend_unArchiveWithKey:(NSString *)key
{
    NSString *saveKey = [NSString stringWithFormat:@"%@.data",key];
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:saveKey];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
// 以key进行升序排序
- (NSArray *)trend_sortWithKey:(NSString *)key
{
    return [self trend_sortWithKey:key ascending:YES];
}
- (NSArray *)trend_sortAsNumber
{
    return [self trend_sortAsNumberWithKey:nil ascending:YES];
}
- (NSArray *)trend_sortAsNumberWithKey:(NSString *)key
{
    return [self trend_sortAsNumberWithKey:key ascending:YES];
}
- (NSArray *)trend_sortAsNumberWithKey:(NSString *)key ascending:(BOOL)ascending
{
    if([NSString isBlankString:key]){
        return [self trend_sortWithBlock:^BOOL(id obj1, id obj2) {
            return ascending ? ([obj1 doubleValue] < [obj2 doubleValue]) : ([obj1 doubleValue] > [obj2 doubleValue]);
        }];
        
    }
    return [self trend_sortWithBlock:^BOOL(id obj1, id obj2) {
        id num1 = [obj1 valueForKeyPath:key];
        id num2 = [obj2 valueForKeyPath:key];
        return ascending ? ([num1 doubleValue] < [num2 doubleValue]) : ([num1 doubleValue] > [num2 doubleValue]);
       }];
    
}
- (NSArray *)trend_sort
{
    return [self trend_sortWithKey:nil ascending:YES];
}
- (NSArray *)trend_sortWithAscending:(BOOL)ascending
{
    return [self trend_sortWithKey:nil ascending:ascending];
}
- (NSArray *)trend_sortWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sorter = nil;
    if(key != nil && [key hasPrefix:@"@"]){
        // 对keypath进行适配
        NSArray *keys = [key componentsSeparatedByString:@"."];
        NSString *prefix = [NSString stringWithFormat:@"%@.self",keys.firstObject];
        NSString *realKey = [[keys trend_subArrayFromIndex:1] componentsJoinedByString:@"."];
        sorter = [NSSortDescriptor sortDescriptorWithKey:realKey ascending:ascending comparator:^NSComparisonResult(id obj1, id obj2) {
            id obj11 = [obj1 valueForKeyPath:prefix];
            id obj21 = [obj2 valueForKeyPath:prefix];
            if (obj11 == obj21) {
                return NSOrderedSame;
            } else if (obj11 > obj21){
                // 当obj1大于obj2时, 本应该返回 NSOrderedDescending , 这里反转其结果, 使返回 NSOrderedAscending
                if(ascending){
                    return NSOrderedDescending;
                }else{
                    return NSOrderedAscending;
                }
            } else {
                if(ascending){
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }
        }];
        
    }else{
        sorter = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    }
    
    return [self sortedArrayUsingDescriptors:@[sorter]];
}
- (NSArray *)trend_sortWithBlock:(TrendSortBlock)block
{
    return [self sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
                if(block(obj1,obj2)){
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
}
- (BOOL)trend_equalTo:(NSArray *)list
{
    // 个数不同的一定不是
    if(self.count != list.count){
        return NO;
    }
    for(NSInteger i=0;i<self.count;i++){
        id obj1 = self[i];
        id obj2 = list[i];
        // 类型不同的一定不是
        if([obj1 class] != [obj2 class]){
            return NO;
        }
        if([obj1 isKindOfClass:[NSString class]] && ![obj1 isEqualToString:obj2]){
            // 都是String但内容不一样的不是
            return NO;
        }else if([obj1 isKindOfClass:[NSNumber class]] && [obj1 doubleValue] != [obj2 doubleValue]){
            // 都是数字但内容大小不一样的不是
            return NO;
        }else if([obj1 respondsToSelector:@selector(trend_equalToObj:)]){
            BOOL result = [(id<TrendEqualProtocol>)obj1 trend_equalToObj:obj2];
            if(!result){
                return NO;
            }
        }else{
            // 没有实现比较两个对应的不是
          return NO;
        }
        
    }
    return YES;
}
@end
#pragma mark -
@implementation NSMutableArray (Trend)
- (void)trend_fillCount:(NSInteger)count fillBlock:(id(^)(NSInteger index))fillBlock
{
    for(NSInteger i=0;i<count;i++){
        if(fillBlock){
            id obj = fillBlock(i);
            if(obj){
                [self addObject:obj];
            }
        }
    }
}
- (void)trend_fillCount:(NSInteger)count fillObj:obj
{
    for(NSInteger i=0;i<count;i++){
        [self addObject:obj];
    }
}
@end
#pragma mark -
@implementation NSDictionary (Trend)
- (NSString *)trend_parse2JsonTxt
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = @"";
    if (error == nil && jsonData != nil) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
#pragma mark -
@implementation NSString (TrendNumber)
- (BOOL)trend_isNumberTxt
{
    if (self.integerValue!=0) {
        return YES;
    }else{
        NSString *ignoreZeroTxt = self;
        while (ignoreZeroTxt.length>1 && [ignoreZeroTxt hasPrefix:@"0"]) {
            ignoreZeroTxt = [ignoreZeroTxt substringFromIndex:1];
        }
        if ([ignoreZeroTxt isEqualToString:@"0"]) {
            return NO;
        }
        return NO;
    }
}
@end
#pragma mark -
@implementation NSMutableDictionary (Combine)
- (void)trend_combineDict:(NSDictionary *)dict
{
    for (NSString *key in dict) {
        self[key] = dict[key];
    }
}
@end
