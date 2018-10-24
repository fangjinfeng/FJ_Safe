//
//  NSObject+Swizzling.h
//  FJ_Safe
//
//  Created by fjf on 2017/3/13.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

/**
 先判断是否添加方法是否成功，如果成功取代原方法，否则交换实例方法

 @param selfClass 类
 @param originalSelector 方法
 @param swizzledSelector 交换方法
 */
+ (void)fjf_exchangeInstanceMethodWithSelfClass:(Class)selfClass
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector;

/**
 直接 类方法 交换

 @param selfClass 类
 @param originalSelector 方法
 @param swizzledSelector 交换方法
 */
+ (void)fjf_exchangeClassMethodWithSelfClass:(Class)selfClass
                            originalSelector:(SEL)originalSelector
                            swizzledSelector:(SEL)swizzledSelector;
@end
