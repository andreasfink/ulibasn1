//
//  UMASN1ObjectPrimitive.m
//  ulibasn1
//
//  Created by Andreas Fink on 06/04/16.
//  Copyright (c) 2016 Andreas Fink (andreas@fink.org)
//

#import "UMASN1ObjectPrimitive.h"

@implementation UMASN1ObjectPrimitive

- (UMASN1ObjectPrimitive *)init
{
    self = [super init];
    if(self)
    {
        [asn1_tag setTagIsPrimitive];
    }
    return self;
}


- (UMASN1ObjectPrimitive *)initWithBerData:(NSData *)data atPosition:(NSUInteger *)pos context:(id)context
{
    self = [super initWithBerData:data atPosition:pos context:context];
    if(self)
    {
        [asn1_tag setTagIsPrimitive];
    }
    return self;
}

@end
