//
//  WordLink.h
//  WordLists
//
//  Created by Neil Taylor on 13/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordPair.h"

typedef enum {
    WLLanguageSettingEnglish,
    WLLanguageSettingWelsh
} WLLanguageSetting;

@interface WordLink : NSObject

@property (strong, nonatomic) NSString *wordPhrase;
@property (strong, nonatomic) NSMutableArray *wordPhraseItems;
@property (strong, nonatomic) NSMutableArray *wordPairs;

- (NSString *) listOfWordsAsString;
- (void) addWordPair: (WordPair *) wordPair withLanguage: (WLLanguageSetting) language;
@end
