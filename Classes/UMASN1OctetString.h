//
//  UMASN1OctetString.h
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import <ulib/ulib.h>
#import "UMASN1Object.h"

@interface UMASN1OctetString : UMASN1Object

- (UMASN1OctetString *)init;
- (UMASN1OctetString *)initWithValue:(NSData *)d;
- (UMASN1OctetString *)initWithString:(NSString *)s;

- (NSData *) value;
- (void) setValue:(NSData *)s;

@end

