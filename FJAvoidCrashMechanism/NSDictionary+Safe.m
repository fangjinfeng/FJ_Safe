//
//  NSDictionary+Safe.m
//  FJ_Safe
//
//  Created by 方金峰 on 2018/10/23.
//  Copyright © 2018年 fjf. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSDictionary (Safe)
#pragma mark -------------------------- Init Methods

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换 removeObjectForKey:
        NSString *tmpRemoveStr = @"dictionaryWithObjects:forKeys:count:";
        NSString *tmpSafeRemoveStr = @"safe_dictionaryWithObjects:forKeys:count:";
        
        [NSObject fjf_exchangeClassMethodWithSelfClass:[self class]
                                         originalSelector:NSSelectorFromString(tmpRemoveStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveStr)];
        
    
        
    });
    
}


#pragma mark -------------------------- Exchange Methods

+ (instancetype)safe_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instance = nil;
    
    @try {
        instance = [self safe_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {

        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self safe_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}
@end
