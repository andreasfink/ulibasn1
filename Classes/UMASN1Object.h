 //
//  UMASN1Object.h
//  ulibasn1
//
//  Created by Andreas Fink on 02.07.14.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.


#import <ulib/ulib.h>

#import "UMASN1Length.h"
#import "UMASN1Tag.h"

typedef enum    UMASN1EncodingType
{
    UMASN1EncodingType_unknownEncoded = 0,
    UMASN1EncodingType_implicitlyEncoded = 1,
    UMASN1EncodingType_explicitlyEncoded = 2,
} UMASN1EncodingType;

NSString *BinaryToNSString(const unsigned char *str, int size);

@interface UMASN1Object : UMObject
{
    UMASN1Tag       *asn1_tag;
    UMASN1Length    *asn1_length;

    NSData          *asn1_data;
    NSMutableArray  *asn1_list;
    BOOL            encodingPreparationDone;
    UMASN1EncodingType encodingType;
}

@property(readwrite,strong) UMASN1Tag       *asn1_tag;
@property(readwrite,strong) UMASN1Length    *asn1_length;
@property(readwrite,strong) NSData          *asn1_data;
@property(readwrite,strong) NSMutableArray  *asn1_list;
@property(readwrite,assign) UMASN1EncodingType encodingType;


- (UMASN1Object *)initWithASN1Object:(UMASN1Object *)obj context:(id)context encoding:(UMASN1EncodingType)encodingType;
- (UMASN1Object *)initWithASN1Object:(UMASN1Object *)obj context:(id)context;
- (UMASN1Object *)initWithBerData:(NSData *)data atPosition:(NSUInteger *)pos context:(id)context;
- (UMASN1Object *)readBerData:(NSData *)data atPosition:(NSUInteger *)pos context:(id)context;

- (NSString *)objectName;
- (id)objectValue;
- (NSString *)objectOperation;


- (UMASN1Object *)processAfterDecodeWithContext:(id)context;

- (BOOL)isEndOfContents;
- (UMASN1Object *)getObjectAtPosition:(NSUInteger)pos;
- (UMASN1Object *)getObjectWithTagNumber:(NSUInteger)nr;
- (UMASN1Object *)getObjectWithTagNumber:(NSUInteger)nr startingAtPosition:(NSUInteger)start;

- (UMASN1Object *)getPrivateObjectWithTagNumber:(NSUInteger)nr;
- (UMASN1Object *)getUniversalObjectWithTagNumber:(NSUInteger)nr;
- (UMASN1Object *)getApplicationSpecificObjectWithTagNumber:(NSUInteger)nr;
- (UMASN1Object *)getContextSpecificObjectWithTagNumber:(NSUInteger)nr;

- (NSString *)stringValue;
- (NSString *)imsiValue;
- (NSString *)isdnValue;
- (NSString *)rawDataAsStringValue;

- (NSData *)berEncoded;
- (void)processBeforeEncode;

+ (uint64_t)classTagNumber;

+(BOOL)tagMatches:(uint64_t)tag;
+ (BOOL)tagMatch:(UMASN1Tag *)t;
- (id)proxyForJson;

@end
