//
//  WordViewTableCell.m
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordViewTableCell.h"
#import "WordPair.h"
#import "WordLink.h"

@interface WordViewTableCell()
@property (weak, nonatomic) IBOutlet UILabel *translation;

@property (weak, nonatomic) IBOutlet UILabel *context;

@end

@implementation WordViewTableCell

- (void) render: (WordPair *) wordPair withLanguage: (WLLanguageSetting) langauge {
    NSLog(@"%@", wordPair);
    switch (langauge) {
        case WLLanguageSettingEnglish:
            self.translation.text = wordPair.welsh;
            break;
        case WLLanguageSettingWelsh:
            self.translation.text = wordPair.english;
            break;
    }
    
    if(wordPair.context != Nil && [wordPair.context length]) {
        self.context.text = [NSString stringWithFormat: @"(%@)", wordPair.context];
    } else {
        self.context.text = Nil;
    }
}

@end
