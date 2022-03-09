//
//  CPCalculate.m
//  Game1537
//
//  Created by apple on 2021/2/15.
//

#import "CPCalculate.h"

@implementation CPCalculate

+ (CPCalculate *)initWithOriginNum:(id)num; {
    NSDecimalNumber *number = [[self class] checkNumber:num];
    if (!number) {
       number = [[NSDecimalNumber alloc] initWithString:@"0"];
    }
    return [[[self class] alloc] initWithOriginNum:number];
}

- (instancetype)initWithOriginNum:(NSDecimalNumber *)num;
{
    self = [super init];
    if (self) {
         _originNum = num;
        [self setupBlock];
    }
    return self;
}


/**
 设置block 调用
 */
- (void)setupBlock {
    __weak typeof(self) weakSelf = self;
    self.add = ^CPCalculate *(id num) {
        [weakSelf add:num];
        return weakSelf;
    };
    self.subtract = ^CPCalculate *(id num) {
        [weakSelf subtract:num];
        return weakSelf;
    };
    self.multiply = ^CPCalculate *(id num) {
        [weakSelf multiply:num];
        return weakSelf;
    };
    self.divide = ^CPCalculate *(id num) {
        [weakSelf divide:num];
        return weakSelf;
    };
}

/**
 加
 
 @param num 加数
 @return self
 */
- (CPCalculate *)add:(id)num; {
    NSDecimalNumber *number = [[self class] checkNumber:num];
    if (number) {
        self.originNum = [self.originNum decimalNumberByAdding:number];
    }
    return self;
}

/**
 减

 @param num 减数
 @return self
 */
- (CPCalculate *)subtract:(id)num; {
    NSDecimalNumber *number = [[self class] checkNumber:num];
    if (number) {
        self.originNum = [self.originNum decimalNumberBySubtracting:number];
    }
    return self;
}

/**
 乘

 @param num 乘数
 @return self
 */
- (CPCalculate *)multiply:(id)num; {
    NSDecimalNumber *number = [[self class] checkNumber:num];
    if (number) {
        self.originNum = [self.originNum decimalNumberByMultiplyingBy:number];
    }
    return self;
}

/**
 除

 @param num 除数
 @return self
 */
- (CPCalculate *)divide:(id)num; {
    NSDecimalNumber *number = [[self class] checkNumber:num];
    if (number) {
        if ([[self class] aDecimalNumberWithStringOrNumberOrDecimalNumber:num compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:@(0)] == 0) {
            NSLog(@"除数不可为零");
        } else {
            self.originNum = [self.originNum decimalNumberByDividingBy:number];
        }
    }
    return self;
}

/**
 检查数字是否符合条件

 @param number 数
 @return NSDecimalNumber
 */
+ (NSDecimalNumber *)checkNumber:(id)number {
    if ([number isKindOfClass:[NSString class]]) {
        return [NSDecimalNumber decimalNumberWithString:number];
    } else if([number isKindOfClass:[NSDecimalNumber class]]) {
        return number;
    } else if ([number isKindOfClass:[NSNumber class]]) {
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else{
        NSLog(@"输入正确的类型");
        return nil;
    }
}


/**
 两个数的比较

 @param num1 第一个数
 @param num2 第二个数
 @return 比较结果
 */
+ (NSComparisonResult)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)num1 compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)num2 {
    NSDecimalNumber *number1 = [CPCalculate checkNumber:num1];
    NSDecimalNumber *number2 = [CPCalculate checkNumber:num2];
    if (!(number1 && number2)) {
        return false;
    }
    return [number1 compare:number2];
}
@end
