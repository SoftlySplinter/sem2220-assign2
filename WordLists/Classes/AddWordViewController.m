//
//  AddWordViewController.m
//  WordLists
//
//  Created by Neil Taylor on 10/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "AddWordViewController.h"

@interface AddWordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *englishField;

@property (weak, nonatomic) IBOutlet UITextField *welshField;

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

- (WordPair *) wordPair {
    
    WordPair *content = [[WordPair alloc] init];
    content.english = self.englishField.text;
    content.welsh = self.welshField.text;
    return content; 
}

@end
