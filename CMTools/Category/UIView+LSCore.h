//
//  UIView+LSCore.h
//  OneNumberDev
//
//  Created by jim on 2019/6/3.
//  Copyright © 2019年 shine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LSCore)

// 设置圆角
+ (void)setCornerRadiusWithView:(UIView *_Nullable)view byRoundingCorners:(UIRectCorner)corners andRadius:(float)radius andStrokeColor:(UIColor *_Nullable)strokeColor;
@end

NS_ASSUME_NONNULL_END
