//
//  WordLink.m
//  WordLists
//
//  Created by Neil Taylor on 13/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordLink.h"

@implementation WordLink

- (id) init {

    if((self = [super init]) != nil) {
        self.wordPhraseItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) listOfWordsAsString {
    return [self.wordPhraseItems componentsJoinedByString: @", "];
}


@end
