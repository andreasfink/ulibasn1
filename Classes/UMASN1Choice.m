//
//  UMASN1Choice.m
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import "UMASN1Choice.h"

@implementation UMASN1Choice

@synthesize choiceType;

- (UMASN1Choice *)init
{
    self = [super init];
    if(self)
    {
        asn1_tag.tagClass = UMASN1Class_Universal;
        asn1_tag.tagNumber = UMASN1Primitive_choice;
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
