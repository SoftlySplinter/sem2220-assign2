//
//  ResultsViewController.m
//  WordLists
//
//  Created by SAW course on 26/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "TranslatorGameResultsViewController.h"

@interface TranslatorGameResultsViewController()
@property (weak, nonatomic) IBOutlet UILabel *scoreField;
@property (weak, nonatomic) IBOutlet UILabel *congratsField;

@end

@implementation TranslatorGameResultsViewController

-(void) viewDidLoad {
    self.scoreField.text = [NSString stringWithFormat:@"%d", self.score];
    switch(self.score) {
        case 10:
            self.congratsField.text = @"You are a master of Welsh";
            break;
        case 9:
        case 8:
        case 7:
            self.congratsField.text = @"Your Welsh is solid, but could be improved";
            break;
        case 6:
        case 5:
        case 4:
            self.congratsField.text = @"You are trying hard, but still have lots of room from improvement";
            break;
        case 3:
        case 2:
        case 1:
            self.congratsField.text = @"You can do better than that";
            break;
        case 0:
        default:
            self.congratsField.text = @"Stick to English";
    }
}

@end
