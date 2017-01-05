
//
//  NSMutableArray+Extension.m
//  fjTestProject
//
//  Created by fjf on 2017/1/3.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //替换 objectAtIndex
        NSString *tmpGetStr = @"objectAtIndex:";
        NSString *tmpSafeGetStr = @"safeMutable_objectAtIndex:";
        
        NSString *tmpRemoveStr = @"removeObjectsInRange:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectsInRange:";
        
        NSString *tmpInsertStr = @"insertObject:atIndex:";
        NSString *tmpSafeInsertStr = @"safeMutable_insertObject:atIndex:";
        
        NSString *tmpRemoveRangeStr = @"removeObject:inRange:";
        NSString *tmpSafeRemoveRangeStr = @"safeMutable_removeObject:inRange:";
        
        
        
        [self exchangeImplementationWithClassStr:@"__NSArrayM" originalMethodStr:tmpGetStr newMethodStr:tmpSafeGetStr];
        
        [self exchangeImplementationWithClassStr:@"__NSArrayM" originalMethodStr:tmpRemoveStr newMethodStr:tmpSafeRemoveStr];
        
        [self exchangeImplementationWithClassStr:@"__NSArrayM" originalMethodStr:tmpInsertStr newMethodStr:tmpSafeInsertStr];
        
        [self exchangeImplementationWithClassStr:@"__NSArrayM" originalMethodStr:tmpRemoveRangeStr newMethodStr:tmpSafeRemoveRangeStr];
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
    
    Method originalMethod = [NSMutableArray methodOfClassStr:classStr selector:NSSelectorFromString(originalMethodStr)];
    Method swizzledMethod = [NSMutableArray methodOfClassStr:classStr selector:NSSelectorFromString(newMethodStr)];
    
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
 取出NSArray 第index个 值
 
 @param index 索引 index
 @return 返回值
 */
- (id)safeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safeMutable_objectAtIndex:index];
}

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)safeMutable_removeObjectsInRange:(NSRange)range {

    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
     return [self safeMutable_removeObjectsInRange:range];
}


/**
 在range范围内， 移除掉anObject

 @param anObject 移除的anObject
 @param range 范围
 */
- (void)safeMutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }

    
    return [self safeMutable_removeObject:anObject inRange:range];

}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)safeMutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
            return;
    }
    
    if (!anObject){
        return;
    }
    
    [self safeMutable_insertObject:anObject atIndex:index];
}
@end
