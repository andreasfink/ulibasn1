//
//  UMASN1Real.h
//  ulibasn1
//
//  Created by Andreas Fink on 06/09/14.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulibasn1/ulibasn1.h>

@interface UMASN1Real : UMASN1Object


- (UMASN1Real *)initWithValue:(double)r;
- (double) value;
- (void) setValue:(double)r;

- (BOOL) isPlusInfinity;
- (BOOL) isMinusInfinity;
- (BOOL) isNotANumber;
- (BOOL) isMinusZero;
- (BOOL) isZero;

- (void) setValueToPlusInfinity;
- (void) setValueToIsNotANumber;
- (void) setValueToMinusInfinity;
- (void) setValueToMinusZero;
- (void) setValueToZero;
+ (double)parseRealString:(const uint8_t *)bytes length:(NSInteger)len;

@end
