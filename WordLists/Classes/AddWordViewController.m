//
//  AddWordViewController.m
//  WordLists
//
//  Created by Neil Taylor on 10/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "AddWordViewController.h"
#import "WordPair.h";

@interface AddWordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *englishField;

@property (weak, nonatomic) IBOutlet UITextField *welshField;

@property (weak, nonatomic) IBOutlet UITextField *contextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSelection;

@property (weak, nonatomic) IBOutlet UITextView *noyesField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AddWordViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WLArea) areaFromSelection: (UISegmentedControl *) selection {
    switch ([selection selectedSegmentIndex]) {
        case 0:
            return WLAreaNorth;
        case 1:
            return WLAreaSouth;
        case 2:
            return WLAreaBoth;
        default:
            return WLAreaNil;
    }
}

- (WordPair *) wordPair {
    
    WordPair *content = [[WordPair alloc] init];
    content.english = self.englishField.text;
    content.welsh = self.welshField.text;
    content.context = self.contextField.text;
    content.area = [self areaFromSelection: self.areaSelection];
    content.notes = self.noyesField.text;
    return content; 
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if(sender == self.doneButton) {
        WordPair *pair = [self wordPair];
        return ([pair.english length] != 0 ||
                [pair.welsh length] != 0);
    }
    return YES;
}

@end
