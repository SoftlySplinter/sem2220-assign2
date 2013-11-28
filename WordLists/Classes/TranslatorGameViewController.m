//
//  RevisionViewController.m
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "TranslatorGameViewController.h"
#import "SharedData.h"
#import "TranslatorGameResultsViewController.h"

#define QUESTIONS 10
#define ATTEMPTS 2
#define CHOICES 4

@interface TranslatorGameViewController()
@property (weak, nonatomic) IBOutlet UIPickerView *answerSelection;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *finalConfirmButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *anserLabel;

@property NSInteger answer;
@property (strong, nonatomic) NSMutableArray *choices;
@property NSInteger questionNumber;
@property NSInteger correct;
@property NSInteger attempts;
@property BOOL shouldSegue;
@property WLLanguageSetting lang;

@end

@implementation TranslatorGameViewController

-(void) viewDidLoad {
    self.choices = [[NSMutableArray alloc] initWithCapacity:CHOICES];
    [self reset];
}

-(void) reset {
    self.questionNumber = 0;
    self.correct = 0;
    self.shouldSegue = NO;
    [self.finalConfirmButton setHidden:YES];
    [self.confirmButton setHidden:NO];
    [self nextQuestion];
}

-(BOOL) answerCorrect {
    return [self.answerSelection selectedRowInComponent:0] == self.answer;
}

-(BOOL) shouldContinueAnyway {
    if(self.attempts < ATTEMPTS - 1) {
        self.attempts++;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Answer" message:[NSString stringWithFormat:@"Invalid Answer, try again (%d attempts remaining)", ATTEMPTS - self.attempts] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil];
        [alert show];
        return NO;
    } else {
        WordPair *answer = self.choices[self.answer];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Answer" message:[NSString stringWithFormat:@"Incorrect Awnser, the correct answer was: %@", answer.english] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil];
        [alert show];
        return YES;
    }
}

- (IBAction)doConfirm:(id)sender {
    if([self answerCorrect] || [self shouldContinueAnyway]) {
        if(self.attempts == 0) self.correct++;
        [self nextQuestion];
    }
}

- (IBAction)doFinalConfirm:(id)sender {
    if([self answerCorrect] || [self shouldContinueAnyway]) {
        if(self.attempts == 0) self.correct++;
        self.shouldSegue = YES;
    }
}

-(void) nextQuestion {
    if(self.questionNumber == QUESTIONS - 1) {
        [self.finalConfirmButton setHidden:NO];
        [self.confirmButton setHidden:YES];
    }
    
    self.attempts = 0;
    self.progress.progress = ((float) self.questionNumber / (float) QUESTIONS);
    [self generateQuestion];
    [self.answerSelection selectRow:0 inComponent:0 animated:NO];
    self.questionNumber++;
}

-(void) generateQuestion {
    [self.choices removeAllObjects];
    
    self.lang = [SharedData randomLanguage];
    while([self.choices count] < CHOICES) {
        WordPair *answerPair = [[SharedData defaultInstance] randomWordPair:self.lang];
        
        if([self.choices containsObject:answerPair]) {
            continue;
        }
        [self.choices addObject:answerPair];
    }
    
    self.answer = arc4random() % [self.choices count];
    WordPair *answerPair = self.choices[self.answer];
    self.anserLabel.text = [answerPair language: self.lang context:YES];
    
    [self.answerSelection reloadAllComponents];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.choices count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    WordPair *pair = self.choices[row];
    
    return [NSString stringWithFormat:@"%@", [pair translation: self.lang context:YES]];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TranslatorGameResultsViewController *results = segue.destinationViewController;
    results.score = self.correct;
    [self reset];
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if(sender == self.finalConfirmButton) {
        return self.shouldSegue;
    }
    return YES;
}



@end
