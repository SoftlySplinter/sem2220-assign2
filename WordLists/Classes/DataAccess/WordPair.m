//
//  WordPair.m
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordPair.h"

@implementation WordPair

- (id)init
{
    self = [super init];
    if (self) {
        self.area = WLAreaBoth;
    }
    return self;
}

+(WLArea) areaFromString:(NSString *)str {
    if(str == Nil || [str length] == 0) return WLAreaBoth;
    switch ([str characterAtIndex:0]) {
        case 'N':
            return WLAreaNorth;
        case 'S':
            return WLAreaSouth;
        case 'B':
            // Fallthrough intended
        default:
            return WLAreaBoth;
    }
}

- (NSString *) description {
    
    return [NSString stringWithFormat: @"%@, %@ (c: %@ a: %@ n: %@", self.english, self.welsh, self.context, [WordPair areaToString: self.area], self.notes];
}

+ (NSString *) areaToString: (WLArea) area {
    switch (area) {
        case WLAreaNorth:
            return @"North";
        case WLAreaSouth:
            return @"South";
        case WLAreaBoth:
            // Fallthrough intended
        default:
            return @"Both";
    }
}

-(NSString *) welshWithContext {
    if([self.context length] < 1) {
        return self.welsh;
    } else {
        return [NSString stringWithFormat:@"%@ (%@)", self.welsh, self.context];
    }
}

-(BOOL) isEqual:(id)object {
    NSLog(@"Is Equal called");
    WordPair *other = (WordPair *) object;
    return [self.english isEqual:other.english] && [self.welsh isEqual:other.welsh];
}

@end
