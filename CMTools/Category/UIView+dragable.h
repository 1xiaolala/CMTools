//
//  UIView+dragable.h
//  Game1537
//
//  Created by jim on 2021/9/2.
//
// 手势拖动view

#import <UIKit/UIKit.h>

@interface UIView (dragable)

@property (nonatomic, copy) NSString *pageName;

- (void)addDragableActionWithEnd:(void (^)(CGRect endFrame))endBlock;
@end
