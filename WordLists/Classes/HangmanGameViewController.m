//
//  HangmanGameViewController.m
//  WordLists
//
//  Created by SAW course on 27/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "HangmanGameViewController.h"
#import "WordPair.h"
#import "SharedData.h"

#define CHANCES 5

@interface HangmanGameViewController() <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *hangmanView;
@property (weak, nonatomic) IBOutlet UILabel *guessWordField;
@property (weak, nonatomic) IBOutlet UILabel *hintWordField;
@property (weak, nonatomic) IBOutlet UITextField *guessLetterInput;
@property (weak, nonatomic) IBOutlet UIButton *guessButton;

@property NSInteger count;
@property (strong, nonatomic) WordPair *guessWord;
@property WLLanguageSetting language;

@property (strong, nonatomic) NSArray *images;

@end

@implementation HangmanGameViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < CHANCES; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"hangman-progress-%d.png", i]];
        NSLog(@"Image: %@", img);
        [imgs addObject:img];
    }
    
    self.images = imgs;
    [self reset];
}

-(void) reset {
    [self.guessLetterInput resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
    self.count = 1;
    [self setHangman: self.count];
    [self loadWord];
}

-(void) loadWord {
    self.language = [SharedData randomLanguage];
    self.guessWord = [[SharedData defaultInstance] randomWordPair:self.language];
    
    self.hintWordField.text = [self.guessWord translation:self.language context:YES];
    
    self.guessWordField.text = @"";
    
    for(NSInteger i = 0; i < [[self.guessWord language:self.language context:NO] length]; i++) {
        self.guessWordField.text = [NSString stringWithFormat:@"%@ _", self.guessWordField.text];
    }
}

-(void) setHangman: (NSInteger) index {
    [self.hangmanView setImage:self.images[index - 1]];
    [self.hangmanView setNeedsDisplay];
}

- (IBAction)onButton:(id)sender {
    NSString *guess = [self.guessLetterInput.text lowercaseString];
    if([guess length] != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Input one letter" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil];
        [alert show];
        return;
    }
    if ([self inWord: guess]) {
        [self addCharacter: guess];
        if([self wordComplete]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Win" message:@"You Guessed the Word Correctly" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil];
            [alert show];
        }
    } else {
        self.count++;
        [self setHangman:self.count];
        if(self.count >= CHANCES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Lose" message:[NSString stringWithFormat:@"The word was: %@", [self.guessWord language:self.language context:NO]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil];
            [alert show];
        } 
    }
    [self.guessLetterInput setText:Nil];
}

- (BOOL) inWord: (NSString *) word {
    NSString *answer = [[self.guessWord language:self.language context:NO] lowercaseString];
    for(NSInteger i = 0; i < [answer length]; i++) {
        if([answer characterAtIndex:i] == [word characterAtIndex:0]) {
            return YES;
        }
    }
    return NO;
}

-(void) addCharacter: (NSString *) charString {
    NSString *answer = [[self.guessWord language:self.language context:NO] lowercaseString];
    for(NSInteger i = 0; i < [answer length]; i++) {
        if([answer characterAtIndex:i] == [charString characterAtIndex:0]) {
            NSRange range;
            range.length = 1;
            range.location = i * 2 + 1;
            NSString *new = [self.guessWordField.text stringByReplacingCharactersInRange:range withString:charString];
            self.guessWordField.text = new;
        }
    }
}

-(BOOL) wordComplete {
    NSString *answer = [[self.guessWord language:self.language context:NO] lowercaseString];
    NSString *progress = [self.guessWordField.text lowercaseString];
    for(NSInteger i = 0; i < [answer length]; i++) {
        if([answer characterAtIndex:i] != [progress characterAtIndex:i*2 + 1]) {
            return NO;
        }
    }
    return YES;

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if([self.guessLetterInput.text length] == 1) {
        [self onButton:textField];
        return NO;
    } else {
        [self.guessLetterInput resignFirstResponder];
        [self dismissViewControllerAnimated:true completion:nil];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self reset];
}

@end
