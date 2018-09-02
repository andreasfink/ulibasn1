//
//  UMASN1Tag.h
//  ulibasn1
//
//  Created by Andreas Fink on 02.07.14.
//  //  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

typedef enum UMASN1ClassType
{
    UMASN1Class_Universal       = 0b00,
    UMASN1Class_Application     = 0b01,
    UMASN1Class_ContextSpecific = 0b10,
    UMASN1Class_Private         = 0b11,
} UMASN1ClassType;

/* from http://luca.ntop.org/Teaching/Appunti/asn1.html */
/* and http://obj-sys.com/asn1tutorial/node124.html */

typedef enum UMASN1PrimitiveType
{
    UMASN1Primitive_choice              = 0x00, /* dummy, you would never see this in the wild */
    UMASN1Primitive_boolean             = 0x01,
    UMASN1Primitive_integer             = 0x02,
    UMASN1Primitive_bitstring           = 0x03,
    UMASN1Primitive_octetstring         = 0x04,
    UMASN1Primitive_null                = 0x05,
    UMASN1Primitive_object_identifier   = 0x06,
    UMASN1Primitive_object_descriptor   = 0x07,
    UMASN1Primitive_external            = 0x08,
    UMASN1Primitive_real                = 0x09,
    UMASN1Primitive_enumerated          = 0x0A,/* found here http://www.obj-sys.com/asn1tutorial/node10.html */
    UMASN1Primitive_sequence            = 0x10,
    UMASN1Primitive_set_of              = 0x11,
    UMASN1Primitive_printable_string    = 0x13,
    UMASN1Primitive_t61_string          = 0x14,
    UMASN1Primitive_ia5_string          = 0x16,
    UMASN1Primitive_utc_time            = 0x17,
//    UMASN1Primitive_real                = 0xFF, /*TO BE VERIFIED */
    
    UMASN1Primitive_UniversalString     = 0x1B, /* In the string type each character is encoded by 4 octets */
    UMASN1Primitive_BMPString           = 0x1D, /* Subset of Unicode character set, each symbol is encoded by 2 octets. */
    UMASN1Primitive_UTF8String          = 0x0B, /* Native Unicode, but with additional post-processing, allowing to encode each symbol in varieties number of characters. */

} UMASN1PrimitiveType;


typedef enum UMASN1PrimitiveOrConstructed
{
    UMASN1Primitive             = 0x00,
    UMASN1Constructed           = 0x20
} UMASN1PrimitiveOrConstructed;

typedef NSInteger   UMASN1TagNumber;

/*!
 @class UMASN1Tag
 @brief  UMASN1Tag represents the ASN1 tag of a PDU
 
 */

@interface  UMASN1Tag : UMObject
{
    UMASN1ClassType                 _tagClass;       /*!< Universal,Application,ContextSpecific,Private  */
    BOOL                            _isConstructed;  /*!< if its a sequence of other objects or not */
    uint64_t                        _tagNumber;      /*!< the tag number is always positive */
}

@property (readwrite,assign) UMASN1ClassType    tagClass;
@property (readwrite,assign) uint64_t           tagNumber;
@property (readwrite,assign) BOOL               isConstructed;

- (BOOL) tagIsPrimitive;
- (BOOL) tagIsConstructed;
- (void) setTagIsConstructed;
- (void) setTagIsPrimitive;

- (UMASN1Tag *)initWithBerData:(NSData *)data atPosition:(NSUInteger *)pos context:(id)context;
- (NSData *) berEncoded;
- (NSString *)name;

@end
