//
//  WordPair.h
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WLAreaNorth,
    WLAreaSouth,
    WLAreaBoth
} WLArea;

typedef enum {
    WLLanguageSettingEnglish,
    WLLanguageSettingWelsh
} WLLanguageSetting;

@interface WordPair : NSObject

@property (strong, nonatomic) NSString *english;
@property (strong, nonatomic) NSString *welsh;
@property (strong, nonatomic) NSString *context;
@property WLArea area;
@property (strong, nonatomic) NSString *notes;

+(WLArea) areaFromString: (NSString *) str;
+(NSString *) areaToString: (WLArea) area;

-(NSString *) language: (WLLanguageSetting) language context: (BOOL) context;
-(NSString *) translation: (WLLanguageSetting) language context: (BOOL) context;


@end
