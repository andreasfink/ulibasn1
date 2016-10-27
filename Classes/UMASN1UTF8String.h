//
//  UMASN1UTF8String.h
//  ulibasn1
//
//  Created by Andreas Fink on 08.09.14.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulibasn1/ulibasn1.h>

@interface UMASN1UTF8String : UMASN1Object

- (UMASN1UTF8String *)initWithValue:(NSString *)s;
- (NSString *) value;
- (void) setValue:(NSString *)v;

@end
