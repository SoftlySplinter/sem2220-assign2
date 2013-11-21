//
//  SharedData.m
//  WordLists
//
//  Created by Neil Taylor on 11/11/2013.
//  Copyright (c) 2013 Aberystwyth University. All rights reserved.
//

#import "SharedData.h"
#import <sqlite3.h>
#import "WordPair.h"
#import "WordLink.h"


@implementation SharedData {
    sqlite3 *db;
}

+ (id) defaultInstance {
    
    static SharedData *instance = nil;
    if(!instance) {
        instance = [[SharedData alloc] init];
        [instance loadDatabase];
    }
    
    return instance;
}

- (NSString *) pathToFileInDocuments:(NSString *) fileName {
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    NSString *path = [documentsDirectory
                      stringByAppendingPathComponent: fileName];
    return path;
}

- (void) createEditableCopyOfDatabaseIfNeeded {
	
  	NSString *writableDBPath =
    [self pathToFileInDocuments: @"words.sqlite"];
	BOOL success = [[NSFileManager defaultManager]
                    fileExistsAtPath:writableDBPath];
    
	if (!success) {
        // the db does not exist in Documents, so create a copy
        NSString *defaultDBPath =
        [[NSBundle mainBundle]
         pathForResource:@"words" ofType:@"sqlite"];
        
        NSError *error;
        success = [[NSFileManager defaultManager]
                   copyItemAtPath:defaultDBPath
                   toPath:writableDBPath
                   error:&error];
        if (!success) {
            NSAssert1(0,
                      @"Failed to create writable database: '%@'.",
                      [error localizedDescription]);
        }
    }
}

- (void) loadDatabase {
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self pathToFileInDocuments: @"words.sqlite"];
    NSLog(@"%@", path);
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK){
		sqlite3_close(db);
        NSString *output = [NSString stringWithFormat: @"Failed to open database %@", path];
		NSAssert(0, output);
	}
}

// NOTE:
// This is code used to just read in words from a the file initialWords.txt.
// It is the same as the code in worksheet 5.
//
// It is useful for having a set of words in the application to start with. I
// have left it in for now. You may want to remove the call to this
// method during development. 
// 
- (void) initialiseWithDataFromFile: (NSString *) filename {
    
    NSString *path =
    [[NSBundle mainBundle]
     pathForResource:@"initalWords" ofType:@"txt"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile: path
                                                       encoding: NSUTF8StringEncoding error:nil];
    
    NSLog(@"file contents: %@ %@", path, fileContents);
    
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:
                      [NSCharacterSet newlineCharacterSet]];
    
    [self deleteRecordsInTable: @"wordLink"];
    [self deleteRecordsInTable: @"english"];
    [self deleteRecordsInTable: @"welsh"];
    
    NSLog(@"Lines: %@", lines);
    
    for(NSString *line in lines) {
        NSArray *elements = [line componentsSeparatedByString: @"|"];
        NSLog(@"elements: %@", elements);
        [self addWordsWithEnglish: elements[0] welsh: elements[1] context: Nil area: WLAreaNil notes: Nil];
    }
}

- (void) deleteRecordsInTable: (NSString *) tableName {
    
    NSString *sqlString = [NSString stringWithFormat: @"DELETE FROM %@;",
                           tableName];
    NSLog(@"sqlite3 string: %@", sqlString);
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error sorting out the db: %@", sqlString);
        return;
    }
    
    if (sqlite3_step(statement) != SQLITE_DONE)
    {
        NSLog(@"Delete failed");
    }
    
}

- (NSInteger) wordPhraseAlreadyExists: (NSString *) wordPhrase forLanguage: (WLLanguageSetting) language {
    NSString *tableId = [self tableIdNameForLanguage: language];
    NSString *tableName = [self tableNameForLanguage: language];
    
    NSString *queryString = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE wordPhrase = '%@';",
                             tableId, tableName, wordPhrase];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to insert link.");
    }
    
    NSInteger result = -1;
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        result = sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    return result;
}

- (NSInteger) insertWordPhrase: (NSString *) wordPhrase
                   forLanguage: (WLLanguageSetting) language {
    
    NSInteger index = [self wordPhraseAlreadyExists: wordPhrase forLanguage:language];
    if(index != -1) {
        return index;
    }
    
    NSString *tableName = [self tableNameForLanguage: language];
    NSString *query = [NSString stringWithFormat: @"INSERT INTO %@ (wordPhrase) values (?)", tableName];
    return [self insertWordWithQuery: query wordPhrase: wordPhrase];
}

- (NSInteger) insertWordWithQuery: (NSString *) queryString
                       wordPhrase: (NSString *) wordPhrase {
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK) {
        NSLog(@"error sorting out the db");
        return -1;
    }
    
    if(sqlite3_bind_text(statement, 1, [wordPhrase UTF8String],
                         -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        return -1;
    }
    
    if (sqlite3_step(statement) != SQLITE_DONE) {
        return -1;
    }
    
    sqlite3_finalize(statement);
    return sqlite3_last_insert_rowid(db);
}

- (void) insertLinkWithEnglishId: (NSInteger) englishId
                         welshId: (NSInteger) welshId {
    
    NSString *queryString = [NSString stringWithFormat: @"INSERT INTO wordLink (englishId, welshId) VALUES (%d, %d)", englishId, welshId];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to insert link.");
    }
    
    if (sqlite3_step(statement) != SQLITE_DONE)
    {
        NSLog(@"Unable to insert values");
    }
    sqlite3_finalize(statement);
    
}

- (void) addWordsWithEnglish: (NSString *) english
                       welsh: (NSString *) welsh
                     context: (NSString *) context
                        area:(WLArea) area
                       notes: (NSString *) notes {
    
    NSInteger englishId = [self insertWordPhrase: english forLanguage: WLLanguageSettingEnglish];
    NSInteger welshId = [self insertWordPhrase: welsh forLanguage: WLLanguageSettingWelsh];
    
    NSLog(@"%d,%d", englishId, welshId);
    
    [self insertLinkWithEnglishId: englishId welshId: welshId];
    
}

- (NSString *) tableIdNameForLanguage: (WLLanguageSetting) language {
    return (language == WLLanguageSettingEnglish) ? @"englishId" : @"welshId";
}

- (NSString *) tableNameForLanguage: (WLLanguageSetting) language {
    return (language == WLLanguageSettingEnglish) ? @"english" : @"welsh";
}

- (NSInteger) numberOfWordsForLanguage:(WLLanguageSetting)language {
    
    NSString *queryString =
    [NSString stringWithFormat: @"SELECT COUNT(*) FROM %@;", [self tableNameForLanguage: language]];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to insert link.");
    }
    
    NSInteger rows = 0;
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        rows = sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    return rows;
}

- (NSInteger) idForIndexPosition: (NSInteger) index language: (WLLanguageSetting) language {
    
    NSString *tableName = [self tableNameForLanguage: language];
    NSString *tableId = [self tableIdNameForLanguage: language];
    
    NSString *queryString =
    [NSString stringWithFormat: @"SELECT %@ FROM %@ ORDER BY wordPhrase LIMIT 1 OFFSET %d;", tableId, tableName, index];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to read id.");
        return -1;
    }
    
    NSInteger wordId = 0;
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        wordId = sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    return wordId;
    
}

- (WordLink *) wordPairForIndexPosition: (NSInteger) index language:(WLLanguageSetting)language {
    
    NSInteger wordId = [self idForIndexPosition: index language: language];
    NSString *tableId = [self tableIdNameForLanguage: language];
    
    NSString *queryString =
    [NSString stringWithFormat: @"SELECT e.wordPhrase, w.wordPhrase FROM english as e, welsh as w, wordLink as wl where wl.englishId = e.englishId and wl.welshId = w.welshId and wl.%@ = %d;",
     tableId, wordId
     ];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to insert link.");
        return nil;
    }
    
    WordLink *wordLink = [[WordLink alloc] init];
    
    NSInteger mainWordPhraseIndex = 0;
    NSInteger secondWordPhraseIndex = 1;
    if(language == WLLanguageSettingWelsh) {
        mainWordPhraseIndex = 1;
        secondWordPhraseIndex = 0;
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        char *itemChar = (char *) sqlite3_column_text(statement, mainWordPhraseIndex);
        wordLink.wordPhrase = [[NSString alloc] initWithUTF8String: itemChar];
        
        itemChar = (char *) sqlite3_column_text(statement, secondWordPhraseIndex);
        [wordLink.wordPhraseItems addObject: [[NSString alloc] initWithUTF8String: itemChar]];
   }
    sqlite3_finalize(statement);
    
    return wordLink;
}

@end
