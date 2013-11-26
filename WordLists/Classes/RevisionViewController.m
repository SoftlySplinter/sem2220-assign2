//
//  RevisionViewController.m
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "RevisionViewController.h"
#import "SharedData.h"
#import "ResultsViewController.h"

#define QUESTIONS 10
#define ATTEMPTS 2
#define CHOICES 4

@interface RevisionViewController()
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

@end

@implementation RevisionViewController

-(void) viewDidLoad {
    self.choices = [[NSMutableArray alloc] initWithCapacity:CHOICES];
}

-(void) viewDidAppear:(BOOL)animated {
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
    NSLog(@"Generating next question");
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
    NSInteger noWords = [[SharedData defaultInstance] numberOfWordsForLanguage:WLLanguageSettingWelsh];
    
    
    while([self.choices count] < CHOICES) {
        NSInteger answerIndex = random() % noWords;
        WordLink *answerWord = [[SharedData defaultInstance] wordPairForIndexPosition:answerIndex language:WLLanguageSettingWelsh];
        WordPair *answerPair = [self selectAnswerFromLink: answerWord];
        
        if([self.choices containsObject:answerPair]) {
            NSLog(@"Dup found...");
            continue;
        }
        
        NSLog(@"Added %@", answerPair);
        [self.choices addObject:answerPair];
    }
    
    NSLog(@"%@", self.choices);
    
    self.answer = random() % [self.choices count];
    WordPair *answerPair = self.choices[self.answer];
    self.anserLabel.text = [answerPair welshWithContext];
    
    [self.answerSelection reloadAllComponents];
}

-(WordPair *) selectAnswerFromLink: (WordLink *) link {
    NSInteger length = [link.wordPairs count];
    NSInteger i = random() % length;
    return [link.wordPairs objectAtIndex:i];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.choices count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    WordPair *pair = self.choices[row];
    return [NSString stringWithFormat:@"%@", pair.english];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultsViewController *results = segue.destinationViewController;
    results.score = self.correct;
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if(sender == self.finalConfirmButton) {
        return self.shouldSegue;
    }
    return YES;
}



@end
