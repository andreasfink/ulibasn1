//
//  UMASN1Choice.h
//  MessageMover
//
//  Created by Andreas Fink on 03.07.14.
//
//

#import <ulib/ulib.h>
#import "UMASN1Object.h"
typedef enum    UMASN1ChoiceType
{
    UMASN1ChoiceType_unknownEncoded = 0,
    UMASN1ChoiceType_implicitlyEncoded = 1,
    UMASN1ChoiceType_explicitlyEncoded = 2,
} UMASN1ChoiceType;

@interface UMASN1Choice : UMASN1Object
{
    UMASN1ChoiceType choiceType;
}

@property(readwrite) UMASN1ChoiceType choiceType;

@end
