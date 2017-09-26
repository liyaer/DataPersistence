//
//  NSArray+DesCription.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/9/26.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "NSArray+DesCription.h"

@implementation NSArray (DesCription)

//方式一(比起方式二打印的效果更佳舒服，推荐使用)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"(\n"];
    for (int i = 0; i < self.count; i++) {
        NSString *lastSymbol = (self.count == i + 1) ? @"":@",";
        id value = self[i];
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@%@\n",tab,[value descriptionWithLocale:locale indent:level + 1],lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@%@\n",tab,value,lastSymbol];
        }
    }
    [mStr appendFormat:@"%@)",tab];
    return mStr;
}

// 方式二（和上面代码达到的效果是一样的，看着下面的比较简洁易懂，用来理解实现原理）
//- (NSString *)descriptionWithLocale:(id)locale
//{
//    NSMutableString *string = [NSMutableString string];
//    
//    // 开头有个[
//    [string appendString:@"[\n"];
//    
//    // 遍历所有的元素
//    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [string appendFormat:@"\t%@,\n", obj];
//    }];
//    
//    // 结尾有个]
//    [string appendString:@"]"];
//    
//    // 查找最后一个逗号
//    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
//    if (range.location != NSNotFound)
//        [string deleteCharactersInRange:range];
//    
//    return string;
//}


/*
 *   优先级 - (NSString )descriptionWithLocale:(id)locale indent:(NSUInteger)level > - (NSString )description。所以，例如NSDictionary，NSArray等，已经实现了- (NSString )descriptionWithLocale:(id)locale indent:(NSUInteger)level此方法，所以如果实现- (NSString )description则没有效果
 */
//-(NSString *)description
//{
//    NSMutableString *string = [NSMutableString string];
//    
//    // 开头有个[
//    [string appendString:@"[\n"];
//    
//    // 遍历所有的元素
//    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [string appendFormat:@"\t%@,\n", obj];
//    }];
//    
//    // 结尾有个]
//    [string appendString:@"]"];
//    
//    // 查找最后一个逗号
//    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
//    if (range.location != NSNotFound)
//        [string deleteCharactersInRange:range];
//    
//    return string;
//}

@end
