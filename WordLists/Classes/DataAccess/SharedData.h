//
//  SharedData.h
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordPair.h"
#import "WordLink.h"

typedef enum {
    WLLanguageSettingEnglish,
    WLLanguageSettingWelsh
} WLLanguageSetting;

@interface SharedData : NSObject

+ (id) defaultInstance;

// NOTE: See the note in the .m file. 
- (void) initialiseWithDataFromFile: (NSString *) filename;

- (void) addWordsWithEnglish: (NSString *) english
                       welsh: (NSString *) welsh
                     context: (NSString *) context
                        area:(WLArea) area
                       notes: (NSString *) notes;

- (NSInteger) numberOfWordsForLanguage: (WLLanguageSetting) language;

- (WordLink *) wordPairForIndexPosition: (NSInteger) index language: (WLLanguageSetting) language;


@end
