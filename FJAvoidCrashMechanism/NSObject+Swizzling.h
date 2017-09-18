//
//  NSObject+Swizzling.h
//  FJ_Safe
//
//  Created by fjf on 2017/3/13.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)
+ (void)exchangeInstanceMethodWithSelfClass:(Class)selfClass
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector;
@end
