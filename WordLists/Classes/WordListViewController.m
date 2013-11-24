//
//  WordListViewController.m
//  WordLists
//
//  Created by Neil Taylor on 10/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordListViewController.h"
#import "SharedData.h"
#import "AddWordViewController.h"
#import "WordTableCell.h"
#import "WordPair.h"
#import "WordViewController.h"

@interface WordListViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageChoice;

@end

@implementation WordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // NOTE: see the explanation in the SharedData.m file for this method
	//
    [[SharedData defaultInstance] initialiseWithDataFromFile: @"initalWords.txt"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancelAdd: (UIStoryboardSegue *) segue {
    NSLog(@"Cancel add operation");
    
}

- (IBAction) confirmAdd: (UIStoryboardSegue *) segue {
    NSLog(@"Confirm add operation");
    AddWordViewController *controller = [segue sourceViewController];
    
    WordPair *wordPair = controller.wordPair;
    
    NSLog(@"WordPair: %@", wordPair);
    
    [[SharedData defaultInstance] addWordsWithEnglish: wordPair.english welsh: wordPair.welsh context: wordPair.context area: wordPair.area notes: wordPair.notes];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (WLLanguageSetting) currentLanguageSetting {
    if([self.languageChoice selectedSegmentIndex] == 0) {
        return WLLanguageSettingEnglish;
    }
    else {
       return WLLanguageSettingWelsh;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    WLLanguageSetting language = [self currentLanguageSetting];
    return [[SharedData defaultInstance] numberOfWordsForLanguage: language];
}

/* 
 * Display the cell.
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WordCell";
    WordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                          forIndexPath:indexPath];
    
    WordLink *words = [[SharedData defaultInstance] wordPairForIndexPosition: indexPath.row
                                                                    language: [self currentLanguageSetting]];
    
    [cell addWordLink: words];
    
    return cell;
}

/* 
 * This is linked to a change in the UISegmentedControl in the navigation bar. 
 * The method is used to reload the data into the table. During the reload 
 * process, the new language setting in the segmented control will be taken 
 * into account. 
 * 
 * See currentLanguageSetting, which is used tableView:cellForRowAtIndexPath:
 */
- (IBAction)languageChanged:(id)sender {

    [self.tableView reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"selectWordSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WordViewController *wordVC = segue.destinationViewController;
        wordVC.wordLink = [[SharedData defaultInstance] wordPairForIndexPosition:indexPath.row language:[self currentLanguageSetting]];
        wordVC.language = [self currentLanguageSetting];
    }
}

@end
