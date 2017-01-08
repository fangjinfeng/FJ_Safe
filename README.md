# FJ_Safe

[FJ_Safe简书链接](http://www.jianshu.com/p/bea2bfed3f3f)

NSString、NSArray、NSMutableString、NSMutableArray、NSMutableDictionary通过运行时直接给原生的插入、删除、截取等操作添加判断，防止崩溃。

由于NSString、NSArray、NSMutableString、NSMutableArray、NSMutableDictionary这几个类型都是Class Clusters（类簇）设计模式设计出来的。

Class Clusters（类簇）是抽象工厂模式在iOS下的一种实现，它是接口简单性和扩展性的权衡体现，在我们完全不知情的情况下，偷偷隐藏了很多具体的实现类，
只暴露出简单的接口。
NSArray 的几个方法来创建实例对象:

    (lldb) po [NSArray array]
    <__NSArray0 0x600000017670>(
    )
    (lldb) po [NSArray arrayWithObject:@"Hello,Zie"];
    <__NSSingleObjectArrayI 0x600000017680>(
    Hello,Zie
    )
    po [NSArray arrayWithObjects:@1,@2, nil];
    <__NSArrayI 0x100500050>(
    1,
    2
    )

通过打印可以看到由 NSArray ，创建的对象并不是 NSArray 本身，有可能是 __NSArray0 、 __NSSingleObjectArrayI 、 __NSArrayI,这里 NSArray 就是那个抽象类，而被创建出来那些奇奇怪的类就是作为具体的实现类，同时是内部私有的,所以替换系统中相应的类型对应的原生方法必须根据他实际实现类。

以NSString为例:

经研究发现NSString实际的实现类有<__NSCFConstantString、NSTaggedPointerString、__NSCFString>这三者，由于NSMutableString主要实现类是<__NSCFString>，所以将<__NSCFString>相应的替代方法放到NSMutableString相关文件里面。


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
    
    这里因为将<__NSCFString>放到NSMutableString类别里面去替换，所以只做实例类<__NSCFConstantString、NSTaggedPointerString>的替换。
因为最终调用替换函数:method_exchangeImplementations(originalMethod, swizzledMethod);，所以:

    NSString *tmpSubFromStr = @"substringFromIndex:"; 
    NSString *tmpSafeSubFromStr = @"safe_substringFromIndex:"; 
    NSString *tmpSafePointSubFromStr = @"safePoint_substringFromIndex:";
    
    每一个实例类别都应该有自己相对应的替换方法,这里tmpSubFromStr是系统的方法，tmpSafeSubFromStr是<__NSCFConstantString>实例类对应的替换方法，tmpSafePointSubFromStr是NSTaggedPointerString对应的替换方法。这里虽然是NSString，可以通过:
    
    SEL originalSelector = NSSelectorFromString(originalMethodStr); 
    SEL swizzledSelector = NSSelectorFromString(newMethodStr);

转换成相应的SEL方法。如果每个实力类没有自己对应的方法，比如说像这样:

    NSString *tmpSubFromStr = @"substringFromIndex:";
    NSString *tmpSafeSubFromStr = @"safe_substringFromIndex:";


    [self exchangeImplementationWithClassStr:@"__NSCFConstantString" originalMethodStr:tmpSubFromStr newMethodStr:tmpSafeSubFromStr];

    [self exchangeImplementationWithClassStr:@"NSTaggedPointerString" originalMethodStr:tmpSubFromStr newMethodStr:tmpSafeSubFromStr];
    
 那最终只会对NSTaggedPointerString原来的substringFromIndex:函数进行替换，<__NSCFConstantString>实例类型的就不起作用。
 
    // 获取 method
    + (Method)methodOfClassStr:(NSString *)classStr selector:(SEL)selector {
       return class_getInstanceMethod(NSClassFromString(classStr),selector);
    }

    // 判断添加 新方法 或 新方法 替换 原来 方法
    + (void)exchangeImplementationWithClassStr:(NSString *)classStr originalMethodStr:(NSString *)originalMethodStr newMethodStr:(NSString *)newMethodStr {

      SEL originalSelector = NSSelectorFromString(originalMethodStr);
      SEL swizzledSelector = NSSelectorFromString(newMethodStr);

      Method originalMethod = [NSString methodOfClassStr:classStr selector:NSSelectorFromString(originalMethodStr)];
      Method swizzledMethod = [NSString methodOfClassStr:classStr selector:NSSelectorFromString(newMethodStr)];

      // 判断 是否 可以添加 新方法
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
          // 替换 原有 方法
          method_exchangeImplementations(originalMethod, swizzledMethod);
     }
    }
这段代码主要通过运行时，先判断是否可以往该实际类里面添加新方法，如果可以则添加新方法，如果不行，则替换原有的方法。但我们要替换的函数一般系统包含，所以只会走替换函数method_exchangeImplementations，但为了系统的健壮性，还是有必要先进行判断。

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

经过下面测试代码，进行测试:

    // __NSCFConstantString 类型
    NSString *tmpConstantString = @"432423432432432432";
    [tmpConstantString substringFromIndex:10000];
    [tmpConstantString substringToIndex:1000];
    [tmpConstantString substringWithRange:NSMakeRange(100, 10000)];
    [tmpConstantString rangeOfString:nil];
    
    // NSTaggedPointerString 类型
    NSString *tmpPointerString = [NSString stringWithFormat:@"4"];
    [tmpPointerString substringFromIndex:10000];
    [tmpPointerString substringToIndex:1000];
    [tmpPointerString substringWithRange:NSMakeRange(100, 10000)];
    [tmpPointerString rangeOfString:nil];
    
    // __NSCFString 类型(备注:类似这样:[NSString stringWithFormat:@"4535435435435"]出来也是__NSCFString,因为NSMutableString初始化出来都是__NSCFString类型，所以归到NSMutableString里面)
    NSMutableString *tmpCFString = [NSMutableString stringWithFormat:@"4535435435435"];
    [tmpCFString substringFromIndex:10000];
    [tmpCFString substringToIndex:1000];
    [tmpCFString substringWithRange:NSMakeRange(100, 10000)];
    [tmpCFString rangeOfString:nil];
    [tmpCFString appendString:nil];
    
    // __NSArray0 类型
    NSArray *tmpZoroArray = [NSArray array];
    tmpZoroArray[100];
    [tmpZoroArray objectAtIndex:1000];
    
    // __NSSingleObjectArrayI 类型
    NSArray *tmpSingleObjectArray = [NSArray arrayWithObject:@"200"];
    tmpSingleObjectArray[100];
    [tmpSingleObjectArray objectAtIndex:1000];
    
    // __NSArrayI 类型
    NSArray *tmpArrayI = [NSArray arrayWithObjects:@"1",@"2", nil];
    tmpArrayI[100];
    [tmpArrayI objectAtIndex:1000];
    
    // __NSArrayM 类型
    NSMutableArray *tmpMutableArrayM = [NSMutableArray arrayWithCapacity:0];
    [tmpMutableArrayM objectAtIndex:1000];
    [tmpMutableArrayM insertObject:nil atIndex:10000];
    [tmpMutableArrayM removeObject:nil];
    [tmpMutableArrayM removeObjectAtIndex:1000];
    [tmpMutableArrayM removeObjectsInRange:NSMakeRange(-100, 10000)];
    
    
    // __NSDictionaryM 类型
    NSMutableDictionary *tmpMutableDictM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100",@"A",@"200",@"B", nil];
    [tmpMutableDictM removeObjectForKey:nil];
    [tmpMutableDictM setObject:nil forKey:@"C"];
    [tmpMutableDictM setObject:@"300" forKey:nil];
    
    像这几种操作都不会导致崩溃。
    
    若有不足，麻烦您指出，谢谢！
