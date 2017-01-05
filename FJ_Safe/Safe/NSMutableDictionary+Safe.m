
//
//  NSMutableDictionary+Extension.m
//  fjTestProject
//
//  Created by fjf on 2017/1/5.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)
#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *tmpRemoveStr = @"removeObjectForKey:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectForKey:";
        
        NSString *tmpSetStr = @"setObject:forKey:";
        NSString *tmpSafeSetRemoveStr = @"safeMutable_setObject:forKey:";
    
        
        [self exchangeImplementationWithClassStr:@"__NSDictionaryM" originalMethodStr:tmpRemoveStr newMethodStr:tmpSafeRemoveStr];
        
        [self exchangeImplementationWithClassStr:@"__NSDictionaryM" originalMethodStr:tmpSetStr newMethodStr:tmpSafeSetRemoveStr];
    });
    
}

// 获取 method
+ (Method)methodOfClassStr:(NSString *)classStr selector:(SEL)selector {
    return class_getInstanceMethod(NSClassFromString(classStr),selector);
}

// 添加 新方法 / 新方法 替换 原来 方法
+ (void)exchangeImplementationWithClassStr:(NSString *)classStr originalMethodStr:(NSString *)originalMethodStr newMethodStr:(NSString *)newMethodStr {
    
    SEL originalSelector = NSSelectorFromString(originalMethodStr);
    SEL swizzledSelector = NSSelectorFromString(newMethodStr);
    
    Method originalMethod = [NSMutableDictionary methodOfClassStr:classStr selector:NSSelectorFromString(originalMethodStr)];
    Method swizzledMethod = [NSMutableDictionary methodOfClassStr:classStr selector:NSSelectorFromString(newMethodStr)];
    
    BOOL didAddMethod =
    class_addMethod(NSClassFromString(classStr),
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(NSClassFromString(classStr),
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark --- implement method

/**
 根据akey 移除 对应的 键值对

 @param aKey key
 */
- (void)safeMutable_removeObjectForKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    [self safeMutable_removeObjectForKey:aKey];
}

/**
 将键值对 添加 到 NSMutableDictionary 内

 @param anObject 值
 @param aKey 键
 */
- (void)safeMutable_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    return [self safeMutable_setObject:anObject forKey:aKey];
}

@end
