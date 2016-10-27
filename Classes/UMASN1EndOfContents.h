//
//  UMASN1EndOfContents.h
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import <ulib/ulib.h>
#import "UMASN1Object.h"

@interface UMASN1EndOfContents : UMASN1Object

- (void)appendToMutableData:(NSMutableData *)d;

@end
