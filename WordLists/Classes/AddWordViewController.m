//
//  AddWordViewController.m
//  WordLists
//
//  Created by Neil Taylor on 10/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "AddWordViewController.h"
#import "WordPair.h"

@interface AddWordViewController () <UITextFieldDelegate>

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
    [self hilightEmpty];
    
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
            // Fallthrough intended
        default:
            return WLAreaBoth;
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

-(void) hilightEmpty {
    WordPair *pair = [self wordPair];
    UIColor *red = [[UIColor alloc] initWithRed:1. green:0.8 blue:0.8 alpha:1.];
    UIColor *def = [[UIColor alloc] initWithRed: 1. green: 1. blue: 1. alpha: 0.];
    if([pair.english length] == 0) {
        [self.englishField setBackgroundColor:red];
    } else {
        [self.englishField setBackgroundColor:def];
    }
    if([pair.welsh length] == 0) {
        [self.welshField setBackgroundColor:red];
    } else {
        [self.welshField setBackgroundColor:def];
    }
}

- (IBAction)doEnglish:(id)sender {
    [self hilightEmpty];
}

- (IBAction)doWelsh:(id)sender {
    [self hilightEmpty];
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if(sender == self.doneButton) {
        WordPair *pair = [self wordPair];
        if([pair.english length] == 0 ||
           [pair.welsh length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Fields" message:@"Cannot add words, there are empty felds" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self hilightEmpty];
            return NO;
        }
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
