//
//  UMASN1ObjectConstructed.m
//  ulibasn1
//
//  Created by Andreas Fink on 06/04/16.
//  Copyright (c) 2016 Andreas Fink (andreas@fink.org)
//

#import "UMASN1ObjectConstructed.h"

@implementation UMASN1ObjectConstructed


- (UMASN1ObjectConstructed *)init
{
    self = [super init];
    if(self)
    {
        [asn1_tag setTagIsConstructed];
        asn1_list = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
