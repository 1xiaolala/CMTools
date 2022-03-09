//
//  UIView+LSCore.m
//  OneNumberDev
//
//  Created by jim on 2019/6/3.
//  Copyright © 2019年 shine. All rights reserved.
//

#import "UIView+LSCore.h"

@implementation UIView (LSCore)

+ (void)setCornerRadiusWithView:(UIView *_Nullable)view byRoundingCorners:(UIRectCorner)corners andRadius:(float)radius andStrokeColor:(UIColor *_Nullable)strokeColor
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.strokeColor = strokeColor.CGColor;
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
@end
