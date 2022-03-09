//
//  PltTimerTarget.h
//  OneNumberDev
//
//  Created by jim on 2019/4/10.
//  Copyright © 2019年 shine. All rights reserved.
//

// 自定义定时器targer

#import <Foundation/Foundation.h>

@interface PltTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
@end
