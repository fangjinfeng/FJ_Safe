//
//  NSArray+Extension.m
//  fjTestProject
//
//  Created by fjf on 2017/1/3.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSArray+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpFirstStr = @"safe_ZeroObjectAtIndex:";
        NSString *tmpThreeStr = @"safe_objectAtIndex:";
        NSString *tmpSecondStr = @"safe_singleObjectAtIndex:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArray0")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpFirstStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSSingleObjectArrayI")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayI")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpThreeStr)];
        
    });

}


#pragma mark --- implement method

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_objectAtIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}


@end
