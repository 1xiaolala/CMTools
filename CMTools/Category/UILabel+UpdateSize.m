//
//  UILabel+UpdateSize.m
//  Lottery
//
//  Created by tony on 2018/11/1.
//  Copyright © 2018年 shine. All rights reserved.
//

#import "UILabel+UpdateSize.h"

@implementation UILabel (UpdateSize)
- (CGFloat)cacluteWidthOfFixedHeight
{
    NSString *txt = self.text;
    CGFloat width = [txt boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{ NSFontAttributeName : self.font }
                                                            context:nil].size.width;
    return width;
}
@end
