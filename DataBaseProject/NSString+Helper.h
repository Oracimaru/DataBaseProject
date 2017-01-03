//
//  NSString+Cat.h
//  Functional
//
//  Created by Nicolas Seriot on 08.01.09.
//  Copyright 2009 Sen:te. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSString (Cat)

+ (BOOL)isBlankString:(NSString *)string;
+ (NSString *)safeString:(NSString *)string;

@end
