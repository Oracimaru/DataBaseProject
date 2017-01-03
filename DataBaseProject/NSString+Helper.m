//
//  NSString+Cat.m
//  Functional
//
//  Created by Nicolas Seriot on 08.01.09.
//  Copyright 2009 Sen:te. All rights reserved.
//

#import "NSString+Helper.h"
#import "NSObject+Empty.h"
@implementation NSString (Cat)

//空字符串的判断
+ (BOOL)isBlankString:(NSString *)string
{
    BOOL result = NO;
    
    if (NULL == string || [string isEqual:nil] || [string isEqual:Nil])
    {
        result = YES;
    }
    else if ([string isEqual:[NSNull null]])
    {
        result = YES;
    }
    else if (0 == [string length] || 0 == [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        result = YES;
    }
    else if([string isEqualToString:@"(null)"] || [string isEqualToString:@"null"] || [string isEqualToString:@"<null>"])
    {
        result = YES;
    }
    
    return result;
}

//字符串“安全化”
+ (NSString *)safeString:(NSString *)string
{
    if([string isKindOfClass:[NSNumber class]])
    {
        NSNumber *num = (NSNumber *)string;
        return num.stringValue;
    }
    else if ([NSObject empty:string]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", string];
}



@end
