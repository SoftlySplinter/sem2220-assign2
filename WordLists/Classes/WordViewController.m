//
//  WordViewController.m
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "WordViewController.h"
#import "WordViewTableCell.h"
#import "ShowWordViewController.h"
#import "WordLink.h"

@interface WordViewController()
@property (weak, nonatomic) IBOutlet UINavigationItem *wordTitle;
@end

@implementation WordViewController

- (void) viewDidLoad {
    self.wordTitle.title = self.wordLink.wordPhrase;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordLink.wordPairs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewWordCell" forIndexPath:indexPath];
    
    [cell render:self.wordLink.wordPairs[indexPath.row] withLanguage:self.language];
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowWordViewController *showWord = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    showWord.wordPair = self.wordLink.wordPairs[indexPath.row];
}

@end
