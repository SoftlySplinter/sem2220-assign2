//
//  RevisionViewController.m
//  WordLists
//
//  Created by SAW course on 24/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "RevisionViewController.h"
#import "SharedData.h"

#define QUESTIONS 10

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

@end

@implementation RevisionViewController

-(void) viewDidLoad {
    self.choices = [[NSMutableArray alloc] initWithCapacity:4];
}

-(void) viewDidAppear:(BOOL)animated {
    self.questionNumber = 0;
    self.correct = 0;
    [self.finalConfirmButton setHidden:YES];
    [self.confirmButton setHidden:NO];
    [self nextQuestion];
}

- (IBAction)doConfirm:(id)sender {
    NSLog(@"This is where logic would happen to check if the answer is right");
    
    if(YES) {
        [self nextQuestion];
    } else {
        
    }
}

- (IBAction)doFinalConfirm:(id)sender {
    NSLog(@"This is where logic would happen to check if the answer is right");
    [self nextQuestion];
}

-(void) nextQuestion {
    NSLog(@"Generating next question");
    if(self.questionNumber == QUESTIONS) {
        [self.finalConfirmButton setHidden:NO];
        [self.confirmButton setHidden:YES];
    }
    
    self.progress.progress = ((float) self.questionNumber / (float) QUESTIONS);
    [self generateQuestion];
    self.questionNumber++;
}

-(void) generateQuestion {
    [self.choices removeAllObjects];
    NSInteger noWords = [[SharedData defaultInstance] numberOfWordsForLanguage:WLLanguageSettingWelsh];
    
    
    while([self.choices count] < 4) {
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
    
    self.answer = random() % 4;
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





@end
