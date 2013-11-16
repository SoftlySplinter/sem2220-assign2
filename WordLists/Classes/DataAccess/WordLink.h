//
//  WordLink.h
//  WordLists
//
//  Created by Neil Taylor on 13/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordLink : NSObject

@property (strong, nonatomic) NSString *wordPhrase;
@property (strong, nonatomic) NSMutableArray *wordPhraseItems;

- (NSString *) listOfWordsAsString;

@end
