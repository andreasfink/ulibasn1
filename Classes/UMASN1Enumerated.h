//
//  UMASN1Enumerated.h
//  ulibasn1
//
//  Created by Andreas Fink on 04/07/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMASN1Integer.h"

@interface UMASN1Enumerated : UMASN1Integer
{
    NSDictionary *_enumDefinition;
}

- (void)setEnumDefinition;

- (UMASN1Enumerated *)initWithString:(NSString *)s;
- (void)setString:(NSString *)s;
- (NSString *)stringValue;
@end
