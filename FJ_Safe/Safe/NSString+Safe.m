
//
//  NSString+Extension.m
//  fjTestProject
//
//  Created by fjf on 2017/1/5.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSString+Safe.h"

@implementation NSString (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *tmpSubFromStr = @"substringFromIndex:";
        NSString *tmpSafeSubFromStr = @"safe_substringFromIndex:";
        NSString *tmpSafePointSubFromStr = @"safePoint_substringFromIndex:";
        
        
        [self exchangeImplementationWithClassStr:@"__NSCFConstantString" originalMethodStr:tmpSubFromStr newMethodStr:tmpSafeSubFromStr];
        
        [self exchangeImplementationWithClassStr:@"NSTaggedPointerString" originalMethodStr:tmpSubFromStr newMethodStr:tmpSafePointSubFromStr];
        
        
        
        NSString *tmpSubToStr = @"substringToIndex:";
        NSString *tmpSafeSubToStr = @"safe_substringToIndex:";
        NSString *tmpSafePointSubToStr = @"safePoint_substringToIndex:";
        
        
        [self exchangeImplementationWithClassStr:@"__NSCFConstantString" originalMethodStr:tmpSubToStr newMethodStr:tmpSafeSubToStr];
        
        [self exchangeImplementationWithClassStr:@"NSTaggedPointerString" originalMethodStr:tmpSubToStr newMethodStr:tmpSafePointSubToStr];
        
        
        
        NSString *tmpSubRangeStr = @"substringWithRange:";
        NSString *tmpSafeSubRangeStr = @"safe_substringWithRange:";
        NSString *tmpSafePointSubRangeStr = @"safePoint_substringWithRange:";
        
        
        [self exchangeImplementationWithClassStr:@"__NSCFConstantString" originalMethodStr:tmpSubRangeStr newMethodStr:tmpSafeSubRangeStr];
        
        [self exchangeImplementationWithClassStr:@"NSTaggedPointerString" originalMethodStr:tmpSubRangeStr newMethodStr:tmpSafePointSubRangeStr];
        
        
        
        NSString *tmpRangeOfStr = @"rangeOfString:options:range:locale:";
        NSString *tmpSafeRangeOfStr = @"safe_rangeOfString:options:range:locale:";
        NSString *tmpSafePointRangeOfStr = @"safePoint_rangeOfString:options:range:locale:";
        
        
        [self exchangeImplementationWithClassStr:@"__NSCFConstantString" originalMethodStr:tmpRangeOfStr newMethodStr:tmpSafeRangeOfStr];
        
        [self exchangeImplementationWithClassStr:@"NSTaggedPointerString" originalMethodStr:tmpRangeOfStr newMethodStr:tmpSafePointRangeOfStr];
        
        
        
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
    
    Method originalMethod = [NSString methodOfClassStr:classStr selector:NSSelectorFromString(originalMethodStr)];
    Method swizzledMethod = [NSString methodOfClassStr:classStr selector:NSSelectorFromString(newMethodStr)];
    
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
/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFConstantString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        return nil;
    }
    return [self safe_substringFromIndex:from];
}
/**
 从from位置截取字符串 对应  NSTaggedPointerString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safePoint_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        return nil;
    }
    return [self safePoint_substringFromIndex:from];
}

/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFConstantString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        return nil;
    }
    return [self safe_substringToIndex:to];
}

/**
 从开始截取到to位置的字符串  对应  NSTaggedPointerString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safePoint_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        return nil;
    }
    return [self safePoint_substringToIndex:to];
}



/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFConstantString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safe_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
         rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
         rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }

    
    return [self safe_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}


/**
 搜索指定 字符串  对应  NSTaggedPointerString

 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safePoint_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }

    
    return [self safePoint_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}

/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFConstantString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safe_substringWithRange:range];
}

/**
 截取指定范围的字符串 对应  NSTaggedPointerString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safePoint_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safePoint_substringWithRange:range];
}

@end
