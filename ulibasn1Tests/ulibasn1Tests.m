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


@end
