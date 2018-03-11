//
//  main.m
//  oid
//
//  Created by Andreas Fink on 11.03.18.
//  Copyright © 2018 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSDictionary *appDefinition = @ {
            @"version" : @"1.0",
            @"executable" : @"oid",
            @"run-as" : @(argv[0]),
            @"copyright" : @"© 2018 Andreas Fink",
        };

        NSArray *commandLineDefinition = @[
                                           @{
                                               @"name"  : @"version",
                                               @"short" : @"-V",
                                               @"long"  : @"--version",
                                               @"help"  : @"shows the software version"
                                               },
                                           @{
                                               @"name"  : @"to-oid",
                                               @"short" : @"-O",
                                               @"long"  : @"--to-oid",
                                               @"multi" : @(YES),
                                               @"argument" : @"hexbytes",
                                               @"help"  : @"convert hex bytes to OID representation",
                                               },
                                           @{
                                               @"name"  : @"to-hex",
                                               @"short" : @"-H",
                                               @"long"  : @"--to-hex",
                                               @"multi" : @(YES),
                                               @"argument" : @"oid-string",
                                               @"help"  : @"convert OID text representation to hex bytes",
                                               },
                                           @{
                                               @"name"  : @"help",
                                               @"short" : @"-h",
                                               @"long" : @"--help",
                                               @"help"  : @"shows the help screen",
                                               }];


        UMCommandLine *cmd = [[UMCommandLine alloc]initWithCommandLineDefintion:commandLineDefinition
                                                                  appDefinition:appDefinition
                                                                           argc:argc
                                                                           argv:argv];
        [cmd handleStandardArguments];

        int tasks = 0;
        NSDictionary *params = cmd.params;
        if(params[@"to-oid"])
        {
            NSArray *a = params[@"to-oid"];
            for(NSString *s in a)
            {
                NSData *data = [s unhexedData];
                UMASN1ObjectIdentifier *oid = [[UMASN1ObjectIdentifier alloc]initWithValue:data];
                NSString *oidPrintable = [oid oidString];
                fprintf(stdout,"%s\n",oidPrintable.UTF8String);
                tasks++;
            }
        }
        if(params[@"to-hex"])
        {
            NSArray *a = params[@"to-hex"];
            for(NSString *s in a)
            {
                UMASN1ObjectIdentifier *oid = [[UMASN1ObjectIdentifier alloc]initWithOIDString:s];
                NSString *oidHexString = [[oid value]hexString];
                fprintf(stdout,"%s\n",oidHexString.UTF8String);
                tasks++;
            }
        }
        if((params[@"to-hex"] == NULL) && (params[@"to-oid"]))
        {
            NSArray *a = cmd.mainArguments;
            for(NSString *s in a)
            {
                NSArray *t = [s componentsSeparatedByString:@"."];
                if(t.count <2)
                {
                    NSData *data = [s unhexedData];
                    UMASN1ObjectIdentifier *oid = [[UMASN1ObjectIdentifier alloc]initWithValue:data];
                    NSString *oidPrintable = [oid oidString];
                    fprintf(stdout,"%s\n",oidPrintable.UTF8String);
                    tasks++;
                }
                else
                {
                    UMASN1ObjectIdentifier *oid = [[UMASN1ObjectIdentifier alloc]initWithOIDString:s];
                    NSString *oidHexString = [[oid value]hexString];
                    fprintf(stdout,"%s\n",oidHexString.UTF8String);
                    tasks++;
                }
            }
        }
        if(tasks == 0)
        {
            [cmd printHelp];
        }
    }
    return 0;
}

