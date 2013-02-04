//
//  VersionComparator.m
//
//  Created by Dan Hanly on 12/06/2012.
//  Copyright (c) 2012 Celf Creative. All rights reserved.
//
//

#import "VersionComparator.h"

@implementation VersionComparator

static NSInteger maxValues = 3;

+ (BOOL)isVersion:(NSString *)versionA greaterThanVersion:(NSString *)versionB{
    
    NSArray *versionAArray = [versionA componentsSeparatedByString:@"."];
    versionAArray = [self normaliseValuesFromArray:versionAArray];
    
    NSArray *versionBArray = [versionB componentsSeparatedByString:@"."];
    versionBArray = [self normaliseValuesFromArray:versionBArray];
    
    for (NSInteger i=0; i<maxValues; i++) {
        if ([[versionAArray objectAtIndex:i] integerValue]>[[versionBArray objectAtIndex:i] integerValue]) {
            return TRUE;
        } else if ([[versionAArray objectAtIndex:i] integerValue]<[[versionBArray objectAtIndex:i] integerValue]) {
            return FALSE;
        }
    }
    return FALSE;
}

+ (NSArray *)normaliseValuesFromArray:(NSArray *)array{
    if([array count]<maxValues){
        NSMutableArray *mutableArray = [array mutableCopy];
#if ! __has_feature(objc_arc)
        [mutableArray autorelease];
#endif
        NSInteger difference = maxValues-[mutableArray count];
        for (NSInteger i=0; i<difference; i++) {
            [mutableArray addObject:@"0"];
        }
        return [NSArray arrayWithArray:mutableArray];
    } else {
        return array;
    }
}

@end
