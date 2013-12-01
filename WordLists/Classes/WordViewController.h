//
//  WordViewController.h
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WordLink.h"

@interface WordViewController : UITableViewController
@property (strong, nonatomic) WordLink *wordLink;
@property WLLanguageSetting language;
@end
