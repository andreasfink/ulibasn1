//
//  UMASN1ObjectIdentifier.m
//  ulibasn1
//
//  Created by Andreas Fink on 20/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMASN1ObjectIdentifier.h"

@implementation UMASN1ObjectIdentifier

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagClass = UMASN1Class_Universal;
    asn1_tag.tagNumber = UMASN1Primitive_object_identifier;
}


- (NSString *)objectName
{
    return @"ObjectIdentifier";
}


+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_object_identifier;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return tag == UMASN1Primitive_object_identifier;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_object_identifier))
    {
        return YES;
    }
    return NO;
}

@end
