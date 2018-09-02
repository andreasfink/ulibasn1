//
//  UMASN1UTF8String.h
//  ulibasn1
//
//  Created by Andreas Fink on 08.09.14.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMASN1Object.h"

@interface UMASN1UTF8String : UMASN1Object

- (UMASN1UTF8String *)initWithValue:(NSString *)s;
- (NSString *) value;
- (void) setValue:(NSString *)v;

@end
