//
//  NSMutableString+Safe.m
//  fjTestProject
//
//  Created by fjf on 2017/1/5.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSMutableString+Safe.h"

@implementation NSMutableString (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *tmpSubFromStr = @"substringFromIndex:";
        NSString *tmpSafeSubFromStr = @"safeMutable_substringFromIndex:";
    
        [self exchangeImplementationWithClassStr:@"__NSCFString" originalMethodStr:tmpSubFromStr newMethodStr:tmpSafeSubFromStr];
        
        
        NSString *tmpSubToStr = @"substringToIndex:";
        NSString *tmpSafeSubToStr = @"safeMutable_substringToIndex:";
    
        [self exchangeImplementationWithClassStr:@"__NSCFString" originalMethodStr:tmpSubToStr newMethodStr:tmpSafeSubToStr];
        
        
        
        NSString *tmpSubRangeStr = @"substringWithRange:";
        NSString *tmpSafeSubRangeStr = @"safeMutable_substringWithRange:";
    
        [self exchangeImplementationWithClassStr:@"__NSCFString" originalMethodStr:tmpSubRangeStr newMethodStr:tmpSafeSubRangeStr];
        
        
        NSString *tmpRangeOfStr = @"rangeOfString:options:range:locale:";
        NSString *tmpSafeRangeOfStr = @"safeMutable_rangeOfString:options:range:locale:";
        
        
        [self exchangeImplementationWithClassStr:@"__NSCFString" originalMethodStr:tmpRangeOfStr newMethodStr:tmpSafeRangeOfStr];
        
        
        NSString *tmpAppendStr = @"appendString:";
        NSString *tmpSafeAppendStr = @"safeMutable_appendString:";
        
        [self exchangeImplementationWithClassStr:@"__NSCFString" originalMethodStr:tmpAppendStr newMethodStr:tmpSafeAppendStr];
        
        
        
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
    
    Method originalMethod = [NSMutableString methodOfClassStr:classStr selector:NSSelectorFromString(originalMethodStr)];
    Method swizzledMethod = [NSMutableString methodOfClassStr:classStr selector:NSSelectorFromString(newMethodStr)];
    
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
 从from位置截取字符串 对应 __NSCFString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safeMutable_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        return nil;
    }
    return [self safeMutable_substringFromIndex:from];
}


/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safeMutable_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        return nil;
    }
    return [self safeMutable_substringToIndex:to];
}



/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safeMutable_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
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
    
    
    return [self safeMutable_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}



/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safeMutable_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safeMutable_substringWithRange:range];
}


/*********************************** safeMutable_appendString:  ***************************/
/**
 追加字符串 对应  __NSCFString
 
 @param aString 追加的字符串
 */
- (void)safeMutable_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    return [self safeMutable_appendString:aString];
}
@end
