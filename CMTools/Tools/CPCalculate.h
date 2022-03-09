//
//  CPCalculate.h
//  Game1537
//
//  Created by apple on 2021/2/15.
//

#import <Foundation/Foundation.h>

@class CPCalculate;

typedef CPCalculate *(^CPCalculateBlock)(id num);

@interface CPCalculate : NSObject

+ (CPCalculate *)initWithOriginNum:(id)num;
@property (nonatomic, strong) NSDecimalNumber *originNum;
@property (nonatomic, copy) CPCalculateBlock add;
@property (nonatomic, copy) CPCalculateBlock subtract;
@property (nonatomic, copy) CPCalculateBlock multiply;
@property (nonatomic, copy) CPCalculateBlock divide;
@end
