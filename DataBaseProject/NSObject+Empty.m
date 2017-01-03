//
//  NSObject+Empty.m
//  FMDB2
//
//  Created by JXT on 15/11/25.
//  Copyright © 2015年 JXT. All rights reserved.
//

#import "NSObject+Empty.h"

#import "NSString+Helper.h"

@implementation NSObject (Empty)

//为空的判断
+ (BOOL)empty:(NSObject *)o
{
    if (o == nil) {
        return YES;
    }
    if (o == NULL) {
        return YES;
    }
    if (o == [NSNull new]) {
        return YES;
    }
    if ([o isKindOfClass:[NSString class]]) {
        return [NSString isBlankString:(NSString *)o];
    }
    if ([o isKindOfClass:[NSData class]]) {
        return [((NSData *)o) length]<=0;
    }
    if ([o isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)o) count]<=0;
    }
    if ([o isKindOfClass:[NSArray class]]) {
        return [((NSArray *)o) count]<=0;
    }
    if ([o isKindOfClass:[NSSet class]]) {
        return [((NSSet *)o) count]<=0;
    }
    
    return NO;
}
@end
