//
//  ShowWordViewController.m
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "ShowWordViewController.h"

@interface ShowWordViewController()
@property (weak, nonatomic) IBOutlet UITextField *english;
@property (weak, nonatomic) IBOutlet UITextField *welsh;
@property (weak, nonatomic) IBOutlet UITextField *context;
@property (weak, nonatomic) IBOutlet UISegmentedControl *area;
@property (weak, nonatomic) IBOutlet UITextView *notes;

@end

@implementation ShowWordViewController

-(void) viewDidLoad {
    self.english.text = self.wordPair.english;
    self.welsh.text = self.wordPair.welsh;
    
    if(self.wordPair.context != Nil && [self.wordPair.context length] != 0) {
        self.context.text = self.wordPair.context;
    }
    
    switch(self.wordPair.area) {
        case WLAreaNorth:
            [self.area setSelectedSegmentIndex:0];
            break;
        case WLAreaSouth:
            [self.area setSelectedSegmentIndex:3];
            break;
        case WLAreaBoth:
            // Fallthrough intended
        default:
            [self.area setSelectedSegmentIndex:2];
            break;
    }

    if(self.wordPair.notes != Nil && [self.wordPair.notes length] != 0) {
        self.notes.text = self.wordPair.notes;
    }
}

@end
