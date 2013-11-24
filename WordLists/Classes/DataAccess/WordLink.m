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
        self.wordPairs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) listOfWordsAsString {
    return [self.wordPhraseItems componentsJoinedByString: @", "];
}

- (void) addWordPair:(WordPair *)wordPair withLanguage:(WLLanguageSetting)language {
    NSLog(@"%@", wordPair);
    [self.wordPairs addObject:wordPair];
    switch(language) {
        case WLLanguageSettingEnglish:
            self.wordPhrase = wordPair.english;
            [self.wordPhraseItems addObject:wordPair.welsh];
            break;
        case WLLanguageSettingWelsh:
            self.wordPhrase = wordPair.welsh;
            [self.wordPhraseItems addObject:wordPair.english];
            break;
    }
}

@end
