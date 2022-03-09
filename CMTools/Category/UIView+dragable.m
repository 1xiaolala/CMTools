//
//  UIView+dragable.m
//  Game1537
//
//  Created by jim on 2021/9/2.
//

#import "UIView+dragable.h"
#import <objc/runtime.h>
#import "Utiles.h"

static const char *ActionHandlerPanGestureKey;

@implementation UIView (dragable)

- (void)addDragableActionWithEnd:(void (^)(CGRect endFrame))endBlock{
    // 添加拖拽手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    // 记录block
    objc_setAssociatedObject(self, ActionHandlerPanGestureKey, endBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:[sender.view superview]];
    
    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;
    
    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat navHeight = 64;
        CGFloat tabHeight = 49;
        CGFloat itemHeight = 5;
        if ([Utiles isIPhoneXSeries]) {
            navHeight = 88;
            tabHeight = 89;
        }
        if ([self.pageName isEqualToString:@"main"]) {
            tabHeight = 0;
        }
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= itemHeight) {
                viewCenter.x = senderHalfViewWidth + itemHeight;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= ([UIScreen mainScreen].bounds.size.width - itemHeight)) {
                viewCenter.x = [UIScreen mainScreen].bounds.size.width - senderHalfViewWidth - itemHeight;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= itemHeight) {
                viewCenter.y = senderHalfViewHeight + itemHeight;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= ([UIScreen mainScreen].bounds.size.height - itemHeight - navHeight - tabHeight)) {
                viewCenter.y = [UIScreen mainScreen].bounds.size.height - senderHalfViewHeight - itemHeight - navHeight - tabHeight;
            }
            sender.view.center = viewCenter;
        } completion:^(BOOL finished) {
            void (^endBlock)(CGRect endFrame) = objc_getAssociatedObject(self, ActionHandlerPanGestureKey);
            if (endBlock) {
                endBlock(sender.view.frame);
            }
        }];
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    } else {
        // UIGestureRecognizerStateBegan || UIGestureRecognizerStateChanged
        viewCenter.x = sender.view.center.x + point.x;
        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    }
}
#pragma mark - Getter and Setter
- (NSString *)pageName {
    return objc_getAssociatedObject(self, @selector(pageName));
}
- (void)setPageName:(NSString *)pageName{
    objc_setAssociatedObject(self, @selector(pageName), pageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
