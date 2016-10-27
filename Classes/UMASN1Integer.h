//
//  UMASN1Integer.h
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import <ulib/ulib.h>
#import "UMASN1Object.h"
#import "UMASN1ObjectPrimitive.h"


@interface UMASN1Integer : UMASN1ObjectPrimitive

- (UMASN1Integer *)initWithValue:(int64_t)i;
- (int64_t) value;
- (void) setValue:(int64_t)v;
- (UMASN1Integer *)initWithString:(NSString *)s;
@end
