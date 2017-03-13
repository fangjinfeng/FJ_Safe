//
//  ViewController.m
//  FJ_Safe
//
//  Created by fjf on 2017/1/5.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    // __NSCFConstantString 类型
//    NSString *tmpConstantString = @"432423432432432432";
//    [tmpConstantString substringFromIndex:10000];
//    [tmpConstantString substringToIndex:1000];
//    [tmpConstantString substringWithRange:NSMakeRange(100, 10000)];
//    [tmpConstantString rangeOfString:nil];
//    
//    // NSTaggedPointerString 类型
//    NSString *tmpPointerString = [NSString stringWithFormat:@"4"];
//    [tmpPointerString substringFromIndex:10000];
//    [tmpPointerString substringToIndex:1000];
//    [tmpPointerString substringWithRange:NSMakeRange(100, 10000)];
//    [tmpPointerString rangeOfString:nil];
//    
//    // __NSCFString 类型(备注:类似这样:[NSString stringWithFormat:@"4535435435435"]出来也是__NSCFString,因为NSMutableString初始化出来都是__NSCFString类型，所以归到NSMutableString里面)
//    NSMutableString *tmpCFString = [NSMutableString stringWithFormat:@"4535435435435"];
//    [tmpCFString substringFromIndex:10000];
//    [tmpCFString substringToIndex:1000];
//    [tmpCFString substringWithRange:NSMakeRange(100, 10000)];
//    [tmpCFString rangeOfString:nil];
//    [tmpCFString appendString:nil];
//    
//    // __NSArray0 类型
//    NSArray *tmpZoroArray = [NSArray array];
//    tmpZoroArray[100];
//    [tmpZoroArray objectAtIndex:1000];
//    
//    // __NSSingleObjectArrayI 类型
//    NSArray *tmpSingleObjectArray = [NSArray arrayWithObject:@"200"];
//    tmpSingleObjectArray[100];
//    [tmpSingleObjectArray objectAtIndex:1000];
//    
//    // __NSArrayI 类型
//    NSArray *tmpArrayI = [NSArray arrayWithObjects:@"1",@"2", nil];
//    tmpArrayI[100];
//    [tmpArrayI objectAtIndex:1000];
//    
    // __NSArrayM 类型
    NSMutableArray *tmpMutableArrayM = [NSMutableArray arrayWithCapacity:0];
    [tmpMutableArrayM objectAtIndex:1000];
    [tmpMutableArrayM insertObject:nil atIndex:10000];
    [tmpMutableArrayM removeObject:nil];
    [tmpMutableArrayM removeObjectAtIndex:1000];
    [tmpMutableArrayM removeObjectsInRange:NSMakeRange(-100, 10000)];
    
    [tmpMutableArrayM addObject:nil];
    
    
    // __NSDictionaryM 类型
    NSMutableDictionary *tmpMutableDictM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100",@"A",@"200",@"B", nil];
    [tmpMutableDictM removeObjectForKey:nil];
    [tmpMutableDictM setObject:nil forKey:@"C"];
    [tmpMutableDictM setObject:@"300" forKey:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
