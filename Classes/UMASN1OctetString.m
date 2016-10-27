//
//  UMASN1OctetString.m
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import "UMASN1OctetString.h"

@implementation UMASN1OctetString


- (UMASN1OctetString *)init
{
    return [self initWithValue:[NSData data]];
}

- (UMASN1OctetString *)initWithValue:(NSData *)d
{
    self = [super init];
    if(self)
    {
        [asn1_tag setTagIsPrimitive];
        asn1_tag.tagClass = UMASN1Class_Universal;
        asn1_tag.tagNumber = UMASN1Primitive_octetstring;
        self.asn1_data = d;
    }
    return self;
}

- (UMASN1OctetString *)initWithString:(NSString *)s
{
    return [self initWithValue:[s unhexedData]];
}


- (NSData *) value
{
    return self.asn1_data;
}

- (void) setValue:(NSData *)s
{
    self.asn1_data = s;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
}


- (NSString *)objectName
{
    return @"OctetString";
}

- (id)objectValue
{
    return self.value;
}

+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_octetstring;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return tag == UMASN1Primitive_octetstring;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_octetstring))
    {
        return YES;
    }
    return NO;
}
@end
