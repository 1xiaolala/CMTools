//
//  NSTimer+TargetTimer.m
//  OneNumberDev
//
//  Created by jim on 2019/4/10.
//  Copyright © 2019年 shine. All rights reserved.
//

#import "NSTimer+TargetTimer.h"
#import "PltTimerTarget.h"

@implementation NSTimer (TargetTimer)

+ (instancetype)pltScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo
{
    PltTimerTarget *timerTarget = [[PltTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:timerTarget selector:@selector(pltTimerTargetAction:) userInfo:userInfo repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timerTarget.timer = timer;
    return timerTarget.timer;
}

@end
