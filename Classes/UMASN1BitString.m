//
//  UMASN1BitString.m
//  ulibasn1
//
//  Created by Andreas Fink on 03.07.14.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.


#import "UMASN1BitString.h"

@implementation UMASN1BitString

- (UMASN1BitString *)init
{
    return [self initWithValue:[NSData data] bitcount:0];
}

- (UMASN1BitString *)initWithValue:(NSData *)d bitcount:(NSInteger)bc
{
    self = [super init];
    if(self)
    {
        asn1_tag.tagClass = UMASN1Class_Universal;
        [asn1_tag setTagIsPrimitive];
        asn1_tag.tagNumber = UMASN1Primitive_bitstring;
        [self setValue:d bitcount:bc];
    }
    return self;
}

- (NSData *)value
{
    NSData *d = [NSData dataWithBytes:self.asn1_data.bytes+1 length:self.asn1_data.length-1];
    return d;
}

-(NSInteger) bitcount
{
    const uint8_t *bytes = self.asn1_data.bytes;
    NSInteger len = (self.asn1_data.length-1) * 8;
    len  = len - *bytes;
    return len;
}

- (void) setValue:(NSData *)s bitcount:(NSInteger)bc
{
    if(bc==0)
    {
        uint8_t byte = 0;
        self.asn1_data = [NSData dataWithBytes:&byte length:1];
    }
    else
    {
        NSInteger trailing_bits = s.length * 8 - bc;

        if(trailing_bits < 0)
        {
            @throw([NSException exceptionWithName:@"ASN1_BITCOUNT_TOO_LARGE"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : @"bitcount is larger than supplied bits",
                                                    @"func": @(__func__),
                                                    @"obj" : self,
                                                    @"backtrace": UMBacktrace(NULL,0)
                                                    }
                    ]);
        }
        if(trailing_bits > 7)
        {
            @throw([NSException exceptionWithName:@"ASN1_BITCOUNT_TOO_SMALL"
                                           reason:NULL
                                         userInfo:@{
                                                    @"sysmsg" : @"bitcount is too small",
                                                    @"func": @(__func__),
                                                    @"obj" : self,
                                                    @"backtrace": UMBacktrace(NULL,0)
                                                    }
                    ]);
        }
        uint8_t byte = trailing_bits;
        NSMutableData *d = [NSMutableData dataWithBytes:&byte length:1];
        [d appendData:s];
        self.asn1_data = d;
    }
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
//    asn1_tag.tagClass = UMASN1Class_Universal;
//    asn1_tag.tagNumber = UMASN1Primitive_bitstring;
}

- (NSString *)objectName
{
    return @"BitString";
}

- (NSString *)objectValue
{
    return [asn1_data hexString];
}


+ (uint64_t)classTagNumber
{
    return UMASN1Primitive_bitstring;
}

+ (BOOL)tagMatches:(uint64_t)tag
{
    return tag == UMASN1Primitive_bitstring;
}

+ (BOOL)tagMatch:(UMASN1Tag *)t
{
    if((t.tagClass == UMASN1Class_Universal) && (t.tagNumber = UMASN1Primitive_bitstring))
    {
        return YES;
    }
    return NO;
}



- (void)extendToBit:(NSInteger)bit
{
    NSInteger byteCount = (bit + 7) / 8;
    
    if(self.asn1_data == NULL)
    {
        NSMutableData *d = [[NSMutableData alloc]init];
        for(NSInteger i=0;i<byteCount;i++)
        {
            [d appendByte:0];
        }
        self.asn1_data = d;
    }
    else if(byteCount > self.asn1_data.length)
    {
        NSMutableData *d = [self.asn1_data mutableCopy];
        for(NSInteger i=self.asn1_data.length;i<byteCount;i++)
        {
            [d appendByte:0];
        }
        self.asn1_data = d;
    }
}

- (void)setBit:(NSInteger)bit
{
    [self extendToBit:bit];
    NSInteger bytePos = (bit+7)/8;
    NSInteger bitPos = (bit % 8);
    NSMutableData *d = [self.asn1_data mutableCopy];
    const uint8_t *b = d.bytes;
    uint8_t val = b[bytePos];
    
    val = val | (1 << bitPos);
    [d replaceBytesInRange:NSMakeRange(bytePos,1) withBytes:&val length:1];
    self.asn1_data = d;
}

- (void)clearBit:(NSInteger)bit
{
    [self extendToBit:bit];
    NSInteger bytePos = (bit+7)/8;
    NSInteger bitPos = (bit % 8);
    NSMutableData *d = [self.asn1_data mutableCopy];
    const uint8_t *b = d.bytes;
    uint8_t val = b[bytePos];
    
    val = val ^ ~(1 << bitPos);
    [d replaceBytesInRange:NSMakeRange(bytePos,1) withBytes:&val length:1];
    self.asn1_data = d;
}

- (BOOL)bit:(NSInteger)bit
{
    [self extendToBit:bit];
    NSInteger bytePos = (bit+7)/8;
    NSInteger bitPos = (bit % 8);
    NSMutableData *d = [self.asn1_data mutableCopy];
    const uint8_t *b = d.bytes;
    uint8_t val = b[bytePos];
    if(val  & (1 << bitPos))
    {
        return YES;
    }
    return NO;
}

@end
