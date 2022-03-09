//
//  LSLDecimalNumberTool.h
//  Game1537
//
//  Created by 张无忌 on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSLDecimalNumberTool : NSDecimalNumber

+ (float)floatWithdecimalNumber:(double)num;

+ (double)doubleWithdecimalNumber:(double)num;

+ (NSString *)stringWithDecimalNumber:(double)num ;

+ (NSDecimalNumber *)decimalNumber:(double)num;
@end

NS_ASSUME_NONNULL_END
