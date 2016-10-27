//
//  UMASN1BitString.h
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import <ulib/ulib.h>
#import "UMASN1Object.h"

@interface UMASN1BitString : UMASN1Object
{
    
}


- (UMASN1BitString *)initWithValue:(NSData *)d bitcount:(NSInteger)bc;
- (NSString *)objectValue;

- (void)setBit:(NSInteger)bit;

@end
