//
//  NSTimer+TargetTimer.h
//  OneNumberDev
//
//  Created by jim on 2019/4/10.
//  Copyright © 2019年 shine. All rights reserved.
//

// 自定义timer分类，解决timer的target强引用对象导致的无法释放问题

#import <Foundation/Foundation.h>

@interface NSTimer (TargetTimer)

+ (instancetype)pltScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo;

@end
