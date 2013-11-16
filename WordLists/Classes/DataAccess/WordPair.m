//
//  WordPair.m
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordPair.h"

@implementation WordPair

- (NSString *) description {
    
    return [NSString stringWithFormat: @"%@, %@", self.english, self.welsh];
}

@end
