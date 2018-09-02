//
//  UMASN1Choice.m
//  ulibasn1
//
//  Created by Andreas Fink on 03.07.14.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMASN1Choice.h"

@implementation UMASN1Choice

@synthesize choiceType;

- (UMASN1Choice *)init
{
    self = [super init];
    if(self)
    {
        self.asn1_tag.tagClass = UMASN1Class_Universal;
        self.asn1_tag.tagNumber = UMASN1Primitive_choice;
    }
    return self;
}


- (NSString *)objectName
{
    return @"Choice";
}

+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_choice;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return YES;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    /* FIXME: check subtypes */
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_bitstring))
    {
        return YES;
    }
    return NO;
}


@end
