
//
//  NSAttributedString+Safe.m
//  FJ_Safe
//
//  Created by 方金峰 on 2018/10/23.
//  Copyright © 2018年 fjf. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import "NSAttributedString+Safe.h"

@implementation NSAttributedString (Safe)
#pragma mark -------------------------- Init Methods

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换 initWithString:
        NSString *tmpStr = @"initWithString:";
        NSString *tmpSafeStr = @"safe_initWithString:";
        
        [NSObject fjf_exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteAttributedString")
                                         originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeStr)];
        
        
        // 替换 initWithAttributedString
        NSString *tmpAttributedStr = @"initWithAttributedString:";
        NSString *tmpSafeAttributedStr = @"safe_initWithAttributedString:";
        
        [NSObject fjf_exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteAttributedString")
                                         originalSelector:NSSelectorFromString(tmpAttributedStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeAttributedStr)];
        
        
        // 替换 initWithString:attributes:
        
        NSString *tmpInitAttributedsStr = @"initWithString:attributes:";
        NSString *tmpSafeInitAttributedsStr = @"safe_initWithString:attributes:";
        
        [NSObject fjf_exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteAttributedString")
                                         originalSelector:NSSelectorFromString(tmpInitAttributedsStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeInitAttributedsStr)];
    
        
    });
    
}

#pragma mark -------------------------- Exchange Methods
#pragma mark - initWithString:

- (instancetype)safe_initWithString:(NSString *)str {
    
    id object = nil;
    
    @try {
        object = [self safe_initWithString:str];
    }
    @catch (NSException *exception) {
       
    }
    @finally {
        return object;
    }
}


//=================================================================
//                          initWithAttributedString
//=================================================================
#pragma mark - initWithAttributedString

- (instancetype)safe_initWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    
    @try {
        object = [self safe_initWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
      
    }
    @finally {
        return object;
    }
}


//=================================================================
//                      initWithString:attributes:
//=================================================================
#pragma mark - initWithString:attributes:

- (instancetype)safe_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    
    @try {
        object = [self safe_initWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return object;
    }
}
@end
