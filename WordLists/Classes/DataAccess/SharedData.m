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
        NSString *notes = Nil;
        WLArea area = WLAreaBoth;
        NSString *context = Nil;
        switch ([elements count]) {
            case 5:
                context = elements[4];
                // Fallthrough intended
            case 4:
                area = [WordPair areaFromString: elements[3]];
                // Fallthrough intended
            case 3:
                notes = elements[2];
        }
        
        [self addWordsWithEnglish: elements[0] welsh: elements[1] context: context area: area notes: notes];
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
    NSString *query = [NSString stringWithFormat: @"INSERT INTO %@ (wordPhrase) VALUES (?)", tableName];
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
                         welshId: (NSInteger) welshId
                         context: (NSString *) context
                            area: (WLArea) area
                           notes: (NSString *) notes {
    if(context == Nil) context = @"";
    if(notes == Nil) notes = @"";
    
    NSString *areaText = [WordPair areaToString:area];
    NSString *queryString = [NSString stringWithFormat:
                             @"INSERT INTO wordLink (englishId, welshId, context, area, notes) \
                             VALUES (%d, %d, ?, '%c', ?)",
                             englishId, welshId,
                             (areaText == Nil) ? ' ' : [areaText characterAtIndex:0]];
    
    sqlite3_stmt *statement;
    
    
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to insert link.");
    }
    
    if(sqlite3_bind_text(statement, 1, [context UTF8String],
                         -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        NSLog(@"DB Error %s", sqlite3_errmsg(db));
        NSLog(@"error binding context to the query to insert link.");
    }
    
    if(sqlite3_bind_text(statement, 2, [notes UTF8String],
                         -1, SQLITE_TRANSIENT) != SQLITE_OK) {
        NSLog(@"error binding notes to the query to insert link.");
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
    
    NSLog(@"%d,%d (c: %@ a: %@ n: %@)", englishId, welshId, context, [WordPair areaToString:area], notes);
    
    [self insertLinkWithEnglishId: englishId welshId: welshId context: context area: area notes: notes];
    
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
    [NSString stringWithFormat: @"SELECT %@ FROM %@ \
     ORDER BY wordPhrase \
     LIMIT 1 \
     OFFSET %d;", tableId, tableName, index];
    
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
    [NSString stringWithFormat: @"SELECT e.wordPhrase, w.wordPhrase, wl.context, wl.area, wl.notes \
     FROM english as e, welsh as w, wordLink as wl \
     WHERE wl.englishId = e.englishId AND wl.welshId = w.welshId AND wl.%@ = %d \
     ORDER BY %@.wordPhrase;",
     tableId, wordId,
     (language == WLLanguageSettingEnglish) ? @"e" : @"w"];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL)
       != SQLITE_OK)
    {
        NSLog(@"error creating the query to insert link.");
        return nil;
    }
    
    WordLink *wordLink = [[WordLink alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        WordPair * wordPair = [[WordPair alloc] init];
        char *itemChar = (char *) sqlite3_column_text(statement, 0);
        wordPair.english = [[NSString alloc] initWithUTF8String: itemChar];
        
        itemChar = (char *) sqlite3_column_text(statement, 1);
        wordPair.welsh = [[NSString alloc] initWithUTF8String:itemChar];
        
        itemChar = (char *) sqlite3_column_text(statement, 2);
        if(itemChar != Nil) {
            wordPair.context = [[NSString alloc] initWithUTF8String:itemChar];
        }
        
        itemChar = (char *) sqlite3_column_text(statement, 3);
        if(itemChar != Nil) {
            wordPair.area = [WordPair areaFromString:[[NSString alloc] initWithUTF8String:itemChar]];
        }
        
        itemChar = (char *) sqlite3_column_text(statement, 4);
        if(itemChar != Nil) {
            wordPair.notes = [[NSString alloc] initWithUTF8String:itemChar];
        }
        
        [wordLink addWordPair: wordPair withLanguage: language];
   }
    sqlite3_finalize(statement);
    
    return wordLink;
}

+(WLLanguageSetting) randomLanguage {
    WLLanguageSetting languages[2] = {WLLanguageSettingEnglish, WLLanguageSettingWelsh};
    return languages[arc4random() % 2];
}

-(WordPair *) randomWordPair: (WLLanguageSetting) language {
    NSInteger noWords = [[SharedData defaultInstance] numberOfWordsForLanguage: language];
    NSInteger answerIndex = arc4random() % noWords;
    WordLink *answerWord = [[SharedData defaultInstance] wordPairForIndexPosition:answerIndex language: language];
    return [self selectAnswerFromLink: answerWord];
}



-(WordPair *) selectAnswerFromLink: (WordLink *) link {
    NSInteger length = [link.wordPairs count];
    NSInteger i = random() % length;
    return [link.wordPairs objectAtIndex:i];
}

@end
