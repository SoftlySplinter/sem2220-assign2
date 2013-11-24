//
//  WordViewTableCell.h
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordPair.h"
#import "WordLink.h"

@interface WordViewTableCell : UITableViewCell

- (void) render: (WordPair *) wordPair withLanguage: (WLLanguageSetting) langauge;
@end
