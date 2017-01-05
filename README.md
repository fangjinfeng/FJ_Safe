# FJ_Safe
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

通过打印可以看到由 NSArray ，创建的对象并不是 NSArray 本身，有可能是 __NSArray0 、 __NSSingleObjectArrayI 、 __NSArrayI ，
这里 NSArray 就是那个抽象类，而被创建出来那些奇奇怪的类就是作为具体的实现类，同时是内部私有的。
所以替换系统中相应的类型对应的原生方法必须根据他实际实现类。
本工程基于类簇对系统的原生方法进行了判断，从而来防止崩溃现象:

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
    
    像这几种操作都不会导致崩溃。也避免了这样的判断
    
    /**
     NSMutableArray 移除 索引 index 对应的 值

     @param index 索引 index
    */
    - (void)removeSafeObjectAtIndex:(NSUInteger)index {
        if (self.count > index) {
            [self removeObjectAtIndex:index];
        }
    }
    有利于项目的维护和app的稳定性。
