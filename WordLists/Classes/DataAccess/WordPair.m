//
//  WordPair.m
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordPair.h"

@implementation WordPair

+(WLArea) areaFromString:(NSString *)str {
    switch ([str characterAtIndex:0]) {
        case 'N':
            return WLAreaNorth;
        case 'S':
            return WLAreaSouth;
        case 'B':
            return WLAreaBoth;
        default:
            return WLAreaNil;
    }
}

- (NSString *) description {
    
    return [NSString stringWithFormat: @"%@, %@ (c: %@ a: %@ n: %@", self.english, self.welsh, self.context, [WordPair areaToString: self.area], self.notes];
}

+ (NSString *) areaToString: (WLArea) area {
    switch (area) {
        case WLAreaNorth:
            return @"N";
        case WLAreaSouth:
            return @"S";
        case WLAreaBoth:
            return @"B";
        case WLAreaNil:
            // Fallthrough intended to catch all cases.
        default:
            return Nil;
    }
}

@end
