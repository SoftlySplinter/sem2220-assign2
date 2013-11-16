//
//  WordTableCell.h
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordPair.h"
#import "SharedData.h"
#import "WordLink.h"

@interface WordTableCell : UITableViewCell

- (void) addWordPair: (WordPair *) words mainLanguage: (WLLanguageSetting) language;

- (void) addWordLink: (WordLink *) wordLink; 

@end
