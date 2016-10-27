//
//  UMASN1Boolean.h
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import <ulib/ulib.h>
#import "UMASN1Object.h"

@interface UMASN1Boolean : UMASN1Object

- (UMASN1Boolean *)initWithValue:(BOOL)value;
- (UMASN1Boolean *)initAsYes;
- (UMASN1Boolean *)initAsNo;
- (BOOL)isTrue;
- (BOOL)isFalse;
- (void)setValue:(BOOL)v;
@end
