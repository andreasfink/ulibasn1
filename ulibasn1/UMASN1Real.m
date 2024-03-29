//
//  UMASN1Real.m
//  ulibasn1
//
//  Created by Andreas Fink on 06/09/14.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibasn1/UMASN1Real.h>

#include <math.h>

@implementation UMASN1Real


- (UMASN1Real *)initWithValue:(double)r
{
    self = [super init];
    if(self)
    {
        self.asn1_tag.tagClass = UMASN1Class_Universal;
        [self.asn1_tag setTagIsPrimitive];
        self.asn1_tag.tagNumber = UMASN1Primitive_real;
        [self setValue:r];
    }
    return self;
}

- (BOOL) isPlusInfinity
{
    if ((self.asn1_data.length == 1) && ((*(uint8_t *)(self.asn1_data.bytes)) == 0x40))
    {
        return YES;
    }
    return NO;
}

- (BOOL) isMinusInfinity
{
    if ((self.asn1_data.length == 1) && ((*(uint8_t *)(self.asn1_data.bytes)) == 0x41))
    {
        return YES;
    }
    return NO;
}

- (BOOL) isNotANumber
{
    if ((self.asn1_data.length == 1) && ((*(uint8_t *)(self.asn1_data.bytes)) == 0x42))
    {
        return YES;
    }
    return NO;

}

- (BOOL) isMinusZero
{
    if ((self.asn1_data.length == 1) && ((*(uint8_t *)(self.asn1_data.bytes)) == 0x43))
    {
        return YES;
    }
    return NO;
}

- (BOOL) isZero
{
    if ((self.asn1_length.length == 0)
        && (self.asn1_length.undefinedLength == NO))
    {
        return YES;
    }
    return NO;
}

- (void) setValueToPlusInfinity
{
    uint8_t byte = 0x40;
    self.asn1_data = [NSData dataWithBytes:&byte length:1];
}

- (void) setValueToMinusInfinity
{
    uint8_t byte = 0x41;
    self.asn1_data = [NSData dataWithBytes:&byte length:1];
}

- (void) setValueToIsNotANumber
{
    uint8_t byte = 0x42;
    self.asn1_data = [NSData dataWithBytes:&byte length:1];
}


- (void) setValueToMinusZero
{
    uint8_t byte = 0x43;
    self.asn1_data = [NSData dataWithBytes:&byte length:1];
}

- (void) setValueToZero
{
    self.asn1_data = [[NSData alloc] init];
}

- (double) value
{
    NSInteger length = self.asn1_length.length;
    if(length==0)
    {
        return 0.00;
    }
   
    const uint8_t *bytes = self.asn1_data.bytes;
    uint8_t firstByte = *bytes;
    
    if(firstByte & 0x80)
    {
        /* binary encoding applies */
        @throw([NSException exceptionWithName:@"ASN1_BINARY_REAL_NOT_IMPLEMENTED"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"decoding of binary real values not implemented",
                                                @"func": @(__func__),
                                                @"obj":self,
                                                @"backtrace": UMBacktrace(NULL,0)
                                                }
                ]);
    }
    else if(firstByte & 0x40)
    {
        if(length !=1)
        {
            @throw([NSException exceptionWithName:@"ASN1_REAL_INVALID_DATA"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : @"real value is special value but length > 1",
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0)
                                                    }
                    ]);
        }
        /* special value applies */
        if(firstByte == 0x40)
        {
            return INFINITY;
        }
        else if(firstByte == 0x41)
        {
            return -INFINITY;
        }
        else if(firstByte == 0x42)
        {
            return NAN;
        }
        else if(firstByte == 0x43)
        {
            return -0.00;
        }
        else
        {
            @throw([NSException exceptionWithName:@"INVALID_DATA"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : [NSString stringWithFormat:@"real value is special value but unknown value 0x%02x",firstByte],
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0),
                                                    }
                    ]);

            return NAN;
        }
    }
    /* decimal value applies */

    if( ((firstByte & 0x3F)== 1) ||
        ((firstByte & 0x3F)== 2) ||
        ((firstByte & 0x3F)== 3))
    {
        return [UMASN1Real parseRealString:&bytes[1] length:length];
    }
    else
    {
        @throw([NSException exceptionWithName:@"INVALID_DATA"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : [NSString stringWithFormat: @"unknown representation value for value 0x%02x",firstByte],
                                                @"func": @(__func__),
                                                @"obj":self,
                                                @"backtrace": UMBacktrace(NULL,0),
                                                }
                ]);
        return NAN;
    }
    return 0;
}

- (void) setValue:(double)d
{
    if(isnan(d))
    {
        [self setValueToIsNotANumber];
    }
    else if(isfinite(d))
    {
        if(copysign(1.0, d) < 0.0)
        {
            [self setValueToMinusInfinity];
        }
        else
        {
            [self setValueToPlusInfinity];
        }
    }
    else if(ilogb(d) <= -INT_MAX)
    {
        if(copysign(1.0, d) < 0.0)
        {
            [self setValueToMinusZero];
        }
        else
        {
            [self setValueToZero];
        }
    }
}


#define LEADING_SPACE_SECTION   0
#define MAIN_DIGITS_SECTION     1
#define FRACTIONS_SECTION       2
#define EXPONENT_SECTION        3
#define EXPONENT_DIGITS_SECTION 4

+ (double)parseRealString:(const uint8_t *)bytes length:(NSInteger)len
{
    /* decoder for ISO 6093 NR1/NR2/NR3 */
    int section = LEADING_SPACE_SECTION;

    double value = 0;
    BOOL value_is_negative = NO;
    int exponent = 0;
    BOOL exponen_is_negative = NO;
    double fractionFactor = 1;
    
    for(NSInteger i=0;i<len;i++)
    {
        char c = bytes[i];
        if(section==LEADING_SPACE_SECTION)
        {
            if(c==' ')
            {
                /* skipping spaces in front */
                continue;
            }
            if(c=='+')
            {
                section = MAIN_DIGITS_SECTION;
                value_is_negative = NO;
                continue;
            }
            if(c=='-')
            {
                section = MAIN_DIGITS_SECTION;
                value_is_negative = YES;
                continue;
            }
            if((c=='.') && (c==','))
            {
                section = FRACTIONS_SECTION;
                continue;
            }
            if((c>='1') && (c<='9'))
            {
                section = MAIN_DIGITS_SECTION;
                value = c - '0';
                continue;
            }
            @throw([NSException exceptionWithName:@"INVALID_CHAR"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : [NSString stringWithFormat:@"invalid character '%c' in NR1 format",c],
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0),
                                                    }
                    ]);
        }
        else if(section==MAIN_DIGITS_SECTION)
        {
            if((c>='1') && (c<='9'))
            {
                value = value * 10;
                value = value + (c - '0');
                continue;
            }
            if(c=='E')
            {
                section = EXPONENT_SECTION;
                continue;
            }
            if((c=='.') && (c==','))
            {
                section = FRACTIONS_SECTION;
                continue;
            }
            @throw([NSException exceptionWithName:@"UNEXPECTED_CHAR"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : [NSString stringWithFormat:@"unexpected character '%c' in NR1 format",c],
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0),
                                                    }
                    ]);
        }
        else if(section==FRACTIONS_SECTION)
        {
            if((c>='1') && (c<='9'))
            {
                fractionFactor = fractionFactor / 10;
                value = value + ((c - '0') * fractionFactor);
                continue;
            }
            if(c=='E')
            {
                section = EXPONENT_SECTION;
                continue;
            }
            @throw([NSException exceptionWithName:@"UNEXPECTED_CHAR"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : [NSString stringWithFormat:@"unexpected character '%c' in NR1 format",c],
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0),
                                                    }
                    ]);
        }
        else if(section==EXPONENT_SECTION)
        {
            if((c>='1') && (c<='9'))
            {
                exponent = (c - '0');
                section = EXPONENT_DIGITS_SECTION;
                continue;
            }
            else if(c=='+')
            {
                section = EXPONENT_DIGITS_SECTION;
                continue;
            }
            else if(c=='-')
            {
                exponen_is_negative = YES;
                section = EXPONENT_DIGITS_SECTION;
                continue;
            }
            @throw([NSException exceptionWithName:@"UNEXPECTED_CHAR"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : [NSString stringWithFormat:@"unexpected character '%c' in exponent section",c],
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0)
                                                    }
                    ]);
        }
        else if(section==EXPONENT_DIGITS_SECTION)
        {
            if((c>='1') && (c<='9'))
            {
                exponent = exponent * 10 + (c - '0');
                section = EXPONENT_DIGITS_SECTION;
                continue;
            }
            @throw([NSException exceptionWithName:@"UNEXPECTED_CHAR"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : [NSString stringWithFormat:@"unexpected character '%c' in exponent digit section",c],
                                                    @"func": @(__func__),
                                                    @"obj":self,
                                                    @"backtrace": UMBacktrace(NULL,0)
                                                    }
                    ]);
        }
    }
    if(value_is_negative)
    {
        value = -value;
    }
    if(exponen_is_negative)
    {
        exponent = -exponent;
    }
    return value * pow(10,exponent);
}

- (NSString *)objectName
{
    return @"Real";
}

- (id) objectValue
{
    return @(self.value);
}

+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_real;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return tag == UMASN1Primitive_real;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_real))
    {
        return YES;
    }
    return NO;
}

@end
