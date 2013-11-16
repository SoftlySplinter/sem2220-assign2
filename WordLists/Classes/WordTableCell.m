//
//  WordTableCell.m
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordTableCell.h"
#import "WordPair.h"

@interface WordTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *wordList;

@end

@implementation WordTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) addWordPair: (WordPair *) words mainLanguage:(WLLanguageSetting)language {
    if(language == WLLanguageSettingEnglish) {
        self.word.text = words.english;
        self.wordList.text = words.welsh;
    }
    else {
        self.word.text = words.welsh;
        self.wordList.text = words.english;
    }
    
}

- (void) addWordLink: (WordLink *) wordLink {
    self.word.text = wordLink.wordPhrase;
    self.wordList.text = [wordLink listOfWordsAsString];
}

@end
