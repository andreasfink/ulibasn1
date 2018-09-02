//
//  UMASN1Enumerated.m
//  ulibasn1
//
//  Created by Andreas Fink on 04/07/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMASN1Enumerated.h"

@implementation UMASN1Enumerated

- (UMASN1Enumerated *)initWithValue:(int64_t)i
{
    self = [super init];
    if(self)
    {
        self.asn1_tag.tagClass = UMASN1Class_Universal;
        [self.asn1_tag setTagIsPrimitive];
        self.asn1_tag.tagNumber = UMASN1Primitive_enumerated;
        [self setValue:i];
    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
}

+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_enumerated;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return tag == UMASN1Primitive_enumerated;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_enumerated))
    {
        return YES;
    }
    return NO;
}

@end
