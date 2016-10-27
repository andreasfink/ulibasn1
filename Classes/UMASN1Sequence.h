//
//  UMASN1Sequence.h
//  ulibasn1
//
//  Created by Andreas Fink on 08.09.14.
//  Copyright (c) 2016 Andreas Fink
//

#import <ulibasn1/ulibasn1.h>

@interface UMASN1Sequence : UMASN1Object

- (UMASN1Sequence *)init;
- (UMASN1Sequence *)initWithValues:(NSArray *)arr;
- (NSArray *)values;
- (void)setValues:(NSArray *)arr;
- (void)appendValue:(UMASN1Object *)o;

@end
