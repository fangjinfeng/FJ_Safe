
//
//  NSMutableAttributedString+Safe.m
//  FJ_Safe
//
//  Created by 方金峰 on 2018/10/23.
//  Copyright © 2018年 fjf. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import "NSMutableAttributedString+Safe.h"

@implementation NSMutableAttributedString (Safe)
#pragma mark -------------------------- Init Methods

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换 initWithString:
        NSString *tmpStr = @"initWithString:";
        NSString *tmpSafeStr = @"safeMutable_initWithString:";
        
        [NSObject fjf_exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                         originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeStr)];
        
        //替换 initWithString:attributes:
        NSString *tmpAttributedStr = @"initWithString:attributes:";
        NSString *tmpSafeAttributedStr  = @"safeMutable_initWithString:attributes:";
        
        [NSObject fjf_exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                         originalSelector:NSSelectorFromString(tmpAttributedStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeAttributedStr)];
        
    });
}

#pragma mark -------------------------- Exchange Methods

#pragma mark --- initWithString:


- (instancetype)safeMutable_initWithString:(NSString *)str {
    id object = nil;
    
    @try {
        object = [self safeMutable_initWithString:str];
    }
    @catch (NSException *exception) {
    }
    @finally {
        return object;
    }
}



#pragma mark --- initWithString:attributes:


- (instancetype)safeMutable_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    
    @try {
        object = [self safeMutable_initWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {

    }
    @finally {
        return object;
    }
}
@end
