//
//  ulibasn1Tests.m
//  ulibasn1Tests
//
//  Created by Andreas Fink on 03/07/14.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ulibasn1.h"

@interface ulibasn1Tests : XCTestCase

@end

@implementation ulibasn1Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDissector
{
    const char data1[] = { /* 0x02,0x01,0x05,0x30,0x30,0x02,0x01,0x47,*/ 0x30,0x2b,0x30,0x29,0xa0,0x22,0x02,0x01,0x79,0x81,0x07,0x91,0x33,0x66,0x00,0x10,0x30,0xf1,0x82,0x07,0x83,0x97,0x36,0x59,0x07,0x00,0x00,0xa3,0x09,0x80,0x07,0x02,0xf8,0x02,0x4e,0xfd,0x4e,0x60,0x89,0x00,0xa1,0x03,0x0a,0x01,0x01 };
    
    NSData *data = [NSData dataWithBytes:data1 length:sizeof(data1)];
    
    NSUInteger pos = 0;
    UMASN1Object *o = [[UMASN1Object alloc]initWithBerData:data atPosition:&pos context:NULL];
    NSLog(@"ASN1 Object =\n%@",o.description);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)verifyInteger:(int64_t)i64 withBytes:(uint8_t *)bytes len:(int)len
{
    NSLog(@"encoding value is %lld",i64);
    if(len == 4)
    {
        NSLog(@"should be { 0x%02x,0x%02x,0x%02x,0x%02x }",bytes[0],bytes[1],bytes[2],bytes[3]);
    }
    else if(len == 3)
    {
        NSLog(@"should be { 0x%02x,0x%02x,0x%02x }",bytes[0],bytes[1],bytes[2]);
    }
    else if(len == 2)
    {
        NSLog(@"should be { 0x%02x,0x%02x }",bytes[0],bytes[1]);
    }

    UMASN1Integer *asn1 = [[UMASN1Integer alloc]initWithValue:i64];
    NSData *data = [asn1 berEncoded];
    NSLog(@"Data is %@",data);
    
    XCTAssert(data.length == len,"encoded size mismatch");
    if(memcmp(data.bytes,bytes,len)!=0)
    {
        XCTFail(@"encoded data mismatch");
    }
    int64_t val = [asn1 value];
    NSLog(@"Decoded value is %lld",val);
    XCTAssert(val == i64,"decoded value is not equal to encoded value");
}

- (void) testBerEncodedIntegerNull
{
    int64_t value = 0;
    uint8_t bytes[] = { 0x02,0x01, 0x00 };
    [self verifyInteger:value withBytes:bytes len: sizeof(bytes)];
}

- (void) testBerEncodedInteger127
{
    int64_t value = 127;
    uint8_t bytes[] = { 0x02,0x01, 0x7F };
    [self verifyInteger:value withBytes:bytes len: sizeof(bytes)];
}


- (void) testBerEncodedInteger128
{
    int64_t value = 128;
    uint8_t bytes[] = { 0x02,0x02, 0x00, 0x80 };
    [self verifyInteger:value withBytes:bytes len: sizeof(bytes)];
}

- (void) testBerEncodedInteger256
{
    int64_t value = 256;
    uint8_t bytes[] = { 0x02,0x02, 0x01, 0x00 };
    [self verifyInteger:value withBytes:bytes len: sizeof(bytes)];
}

- (void) testBerEncodedIntegerMinus128
{
    int64_t value = -128;
    uint8_t bytes[] = { 0x02,0x01, 0x80 };
    [self verifyInteger:value withBytes:bytes len: sizeof(bytes)];
}

- (void) testBerEncodedIntegerMinus129
{
    int64_t value = -129;
    uint8_t bytes[] = { 0x02,0x02, 0xFF, 0x7F };
    [self verifyInteger:value withBytes:bytes len: sizeof(bytes)];
}

- (void) testBerEncodedIntegers
{
    int64_t i;
    for(i=-33000;i< 33000;i++)
    {
        UMASN1Integer *asn1 = [[UMASN1Integer alloc]initWithValue:i];
        int64_t val = [asn1 value];
        XCTAssert(val == i,"decoded value is not equal to encoded value for i=%lld",i);
    }
}

- (void)testTcapDecode1
{
    const unsigned char data1[] = { 0x62, 0x81, 0xCA, 0x48, 0x04, 0x46, 0x00, 0xE3, 0x20, 0x6C, 0x81, 0xC1, 0xA1, 0x81, 0xBE, 0x02, 0x01, 0x01, 0x02, 0x01, 0x2E, 0x30, 0x80, 0x80, 0x07, 0x34, 0x08, 0x12, 0x00, 0x00, 0x32, 0xF4, 0x84, 0x07, 0x91, 0x09, 0x35, 0x92, 0x10, 0x00, 0x00, 0x04, 0x81, 0x9F, 0x64, 0x0C, 0x91, 0x09, 0x35, 0x58, 0x19, 0x38, 0x46, 0x00, 0x00, 0x71, 0x70, 0x21, 0x21, 0x23, 0x05, 0x21, 0xA0, 0x05, 0x00, 0x03, 0xEB, 0x03, 0x01, 0x84, 0x41, 0x6A, 0x52, 0x9A, 0x48, 0x2E, 0x41, 0x20, 0xA8, 0x34, 0x69, 0x2D, 0x52, 0x41, 0x20, 0x2A, 0x08, 0xD4, 0x0C, 0x4E, 0x83, 0x20, 0x10, 0x54, 0x9A, 0x2C, 0x22, 0x83, 0xCC, 0x20, 0x08, 0x34, 0x05, 0x81, 0x82, 0x53, 0x64, 0x50, 0x18, 0x24, 0x06, 0x41, 0xA0, 0x24, 0x08, 0x34, 0x5D, 0x06, 0xB5, 0x41, 0x66, 0x10, 0x04, 0x12, 0x26, 0x99, 0x45, 0x6A, 0x12, 0x04, 0xB2, 0x82, 0x40, 0x4F, 0xA2, 0xB3, 0x0A, 0x02, 0x4D, 0xA9, 0x4F, 0xE9, 0xD3, 0x59, 0x05, 0x81, 0x98, 0x45, 0x6A, 0x91, 0x0A, 0x02, 0xC5, 0x6E, 0x35, 0x10, 0x88, 0xF8, 0x64, 0x06, 0xA5, 0x4F, 0x2B, 0x08, 0x54, 0x9C, 0x32, 0x93, 0x20, 0x10, 0xB5, 0x4A, 0x0C, 0x82, 0x40, 0x4F, 0xA1, 0x34, 0x48, 0x75, 0x3E, 0x41, 0xA0, 0x59, 0x0D, 0x06, 0x02, 0x11, 0x9F, 0xCC, 0xA0, 0xF4, 0x69, 0x05, 0x81, 0x9C, 0x4F, 0x10, 0x68, 0x59, 0x85, 0x26, 0xA9, 0x00, 0x00 };
/* this should result in this
    APPLICATION [2] CONSTRUCTED	LENGTH=202
    {
        APPLICATION [8] PRIMITIVE	LENGTH=4	<4600e320>
        APPLICATION [12] CONSTRUCTED	LENGTH=193
        {
            CONTEXT_SPECIFIC [1] CONSTRUCTED	LENGTH=190
            {
                UNIVERSAL [2] PRIMITIVE	LENGTH=1	<01>
                UNIVERSAL [2] PRIMITIVE	LENGTH=1	<2e>
                UNIVERSAL [16] CONSTRUCTED	UNDEFINED_LENGTH
                {
                    CONTEXT_SPECIFIC [0] PRIMITIVE	LENGTH=7	<34081200 0032f4>
                    CONTEXT_SPECIFIC [4] PRIMITIVE	LENGTH=7	<91093592 100000>
                    UNIVERSAL [4] PRIMITIVE	LENGTH=159	<640c9109 35581938 46000071 70212123 0521a005 0003eb03 0184416a 529a482e 4120a834 692d5241 202a08d4 0c4e8320 10549a2c 2283cc20 08340581 82536450 18240641 a0240834 5d06b541 66100412 2699456a 1204b282 404fa2b3 0a024da9 4fe9d359 05819845 6a910a02 c56e3510 88f86406 a54f2b08 549c3293 2010b54a 0c82404f a1344875 3e41a059 0d060211 9fcca0f4 6905819c 4f106859 8526a9>
                }
            }
        }
    }
*/
    NSData *data = [NSData dataWithBytes:data1 length:sizeof(data1)];

    NSUInteger pos = 0;
    UMASN1Object *o = [[UMASN1Object alloc]initWithBerData:data atPosition:&pos context:NULL];
    NSLog(@"TCAP Object =\n%@",o.description);

}
@end
