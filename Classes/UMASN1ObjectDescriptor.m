//
//  UMASN1ObjectDescriptor.m
//  ulibasn1
//
//  Created by Andreas Fink on 20/04/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//

#import "UMASN1ObjectDescriptor.h"

@implementation UMASN1ObjectDescriptor

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagClass = UMASN1Class_Universal;
    asn1_tag.tagNumber = UMASN1Primitive_object_descriptor;
}

+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_object_descriptor;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return tag == UMASN1Primitive_object_descriptor;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_object_descriptor))
    {
        return YES;
    }
    return NO;
}


@end
