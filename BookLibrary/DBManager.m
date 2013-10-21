//
//  DBManager.m
//  BookLibrary
//
//  Created by Goutham on 18/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}
 
-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"booklibrary.db"]];
   
    NSLog(@"%@",databasePath);
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        NSLog(@"hello");
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS BookDetail (ISBN TEXT,TITLE TEXT,AUTHOR TEXT, PUBLISHER TEXT, CATEGORY TEXT,DESCRIPTION TEXT,RATING TEXT,copies int,archive bool)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                
                NSLog(@"%s",sqlite3_errmsg(database));
                NSLog(@"Failed to create table");
            }
            else
            {
               sql_stmt= "CREATE TABLE IF NOT EXISTS transactions(ISBN TEXT,username TEXT,emailid TEXT, issuedate TEXT, duedate TEXT,status bool)";
                if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                    != SQLITE_OK)
                {
                    isSuccess = NO;
                     NSLog(@"%s",sqlite3_errmsg(database));
                    NSLog(@"Failed to create table");
                }
                else
                {
                    sql_stmt= "CREATE TABLE IF NOT EXISTS completed(ISBN TEXT,emailid TEXT,issuedate TEXT,duedate TEXT)";
                    if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                        != SQLITE_OK)
                    {
                        isSuccess = NO;
                         NSLog(@"%s",sqlite3_errmsg(database));
                        NSLog(@"Failed to create table");
                    }

                }
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString*)isbn title:(NSString*)title
           author:(NSString*)author publisher:(NSString*)publisher category:(NSString*)category description:(NSString*)description rating:(NSString*)rating copies:(NSInteger)copies archive:(BOOL)archive;
{
       
    BOOL isInserted=YES;
    sqlite3_stmt *statement;
   
    
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"insert into BookDetail values(\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\")",isbn,title,author,publisher,category,description,rating,copies,archive];
           
           
            const char *insert_stmt = [insertSQL UTF8String];
            NSLog(@"%s",insert_stmt);
            if(sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
               
                 if (sqlite3_step(statement) == SQLITE_DONE)
                 {
                   NSLog(@"string added");
                 }
                 else
                 {
                   NSLog(@"%s",sqlite3_errmsg(database));
                   isInserted=NO;
                 }
            }
           
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
    
    return isInserted;
}

- (BOOL) saveData:(NSString*)isbn username:(NSString*)username
           emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate status:(BOOL)status
{
    bool isinserted=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into transactions values(\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%d\")",isbn,username,emailid,issuedate,duedate,status];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            isinserted=YES;
        }
        else {
            isinserted=NO;
        }
        sqlite3_reset(statement);
    }
    sqlite3_close(database);
    return isinserted;
}
- (BOOL) saveData:(NSString*)isbn
          emailid:(NSString*)emailid issuedate:(NSString*)issuedate returndate:(NSString*)returndate;
{
    bool isinserted=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into completed values(\"%@\",\"%@\", \"%@\", \"%@\")",isbn,emailid,issuedate,returndate];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            isinserted=YES;
            
        }
        else {
            isinserted=NO;
        }
        sqlite3_reset(statement);
    }
    return isinserted;
}
- (NSInteger)searchISBN:(NSString*)isbn
{
    NSInteger count=0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select count(*) from bookDetail where isbn=\"%@\" and archive=0",isbn];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                count=sqlite3_column_int(statement, 0);
            }
            sqlite3_reset(statement);
        }
       
        
    }
    sqlite3_close(database);
    return count;
}
-(NSMutableArray*) searchEmailidsByISBN:(NSString*)isbn
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select emailid from transactions where isbn=\"%@\" and status=1",isbn];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *emailid = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [arr addObject:emailid];
                
            }
           
            sqlite3_reset(statement);
        }
        sqlite3_close(database);
    }
    
    return arr;
}
-(NSMutableArray*) findDetailsByISBN:(NSString*)isbn
{
    NSMutableArray *arr;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from bookDetail where isbn=\"%@\" and archive=0",isbn];
       
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *publisher = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *author=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *category=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *description=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *rating=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
              //  NSData *imgdata=[NSData dataWithBytes:sqlite3_column_blob(statement, 7) length:sqlite3_column_bytes(statement, 7)] ;
                NSString *title=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                int copies=sqlite3_column_int(statement, 8);
            
            arr=[[NSMutableArray alloc] initWithObjects:isbn,title,author,publisher,category,description,rating,[NSNumber numberWithInt:copies],nil];
               
            }
            sqlite3_reset(statement);
        }
         sqlite3_close(database);
    }
    return arr;
    
}
-(NSInteger)searchCopies:(NSString*)isbn
{
    NSInteger count=0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select copies from bookDetail where isbn=\"%@\" and archive=0",isbn];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                count=sqlite3_column_int(statement, 0);

            }
            sqlite3_reset(statement);
        }
        
        
    }
    sqlite3_close(database);
    return count;

}
-(BOOL)updateCopies:(NSString*)isbn copies:(NSInteger)copies
{
    NSInteger count=[self searchCopies:isbn];
    NSInteger sum=count + copies;
    BOOL success=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:
                              @"update bookDetail set copies=\"%d\" where isbn=\"%@\" and archive=0",sum,isbn];
        const char *query_stmt = [updateSQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success=YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(database));
                success=NO;
            }
            sqlite3_reset(statement);

            
        }
        
        
    }
    sqlite3_close(database);
    return success;
    
}
-(NSString*)deleteTransaction:(NSString*)isbn email:(NSString*)email
{
    NSString *issuedate=[[NSString alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL=[NSString stringWithFormat:@"select issuedate from transactions where isbn=\"%@\" and emailid=\"%@\" and status=1",isbn,email];
        NSString *updateSQL = [NSString stringWithFormat:
                               @"delete from transactions where isbn=\"%@\" and emailid=\"%@\" and status=1",isbn,email];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"%s",query_stmt);
        if(sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            NSLog(@"hello");
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                issuedate= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSLog(@"%@",issuedate);
                 sqlite3_reset(statement);
               const char *delete_stmt = [updateSQL UTF8String];
                sqlite3_prepare_v2(database,
                                   delete_stmt, -1, &statement, NULL);
                sqlite3_step(statement);
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
       sqlite3_close(database);
    }
    

    return issuedate;
}
-(NSMutableArray*)getTransactionsByStatus:(BOOL)status
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    NSMutableArray *sortedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *dict;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from transactions where status=\"%d\"",status];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                dict=[[NSMutableDictionary alloc] init];
                NSString *isbn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [dict setObject:isbn forKey:@"isbn"];
                NSString *emailid=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                 [dict setObject:emailid forKey:@"emailid"];
                NSString *issuedate=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                [dict setObject:issuedate forKey:@"issuedate"];
                NSString *duedate=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                [dict setObject:duedate forKey:@"duedate"];
                
                [arr addObject:dict];
                
            }
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"duedate"  ascending:YES];
            arr=[arr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
            sortedArray = [arr copy];
            id obj;
            NSEnumerator * enumerator = [arr objectEnumerator];
            enumerator = [sortedArray objectEnumerator];
            NSLog(@"\n :::sorted array:::");
            while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);
            

            
            sqlite3_reset(statement);
        }
        sqlite3_close(database);
    }
    return sortedArray;

}

-(NSMutableArray*)completedTransactions
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from completed"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                dict=[[NSMutableDictionary alloc] init];
                NSString *isbn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                [dict setObject:isbn forKey:@"isbn"];
                NSString *emailid=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                [dict setObject:emailid forKey:@"emailid"];
                NSString *issuedate=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                [dict setObject:issuedate forKey:@"issuedate"];
                NSString *returndate=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                [dict setObject:returndate forKey:@"returndate"];
                
                [arr addObject:dict];
                
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(database);
    }
    return arr;
    
}
-(NSString*) getBookNameByISBN:(NSString*)isbn
{
    NSString *title;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select title from bookDetail where isbn=\"%@\" and archive=0",isbn];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
            title=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(database);
    }
    return title;
}

-(NSMutableArray*) findDetailForCategory:(NSString*)category
{
    NSMutableArray *arrForFetchingBookInfo=[[NSMutableArray alloc] init];
    NSMutableDictionary *bookInfoDict;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM BookDetail WHERE CATEGORY=\"%@\"",category];
       
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                    
                    bookInfoDict=[[NSMutableDictionary alloc]init];
                    
                    NSString *publisher = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    [bookInfoDict setValue:publisher forKey:@"publisher"];
                   
                    
                    NSString *author=[NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    [bookInfoDict setValue:author forKey:@"author"];
                    
                    
                    NSString *isbn=[NSString  stringWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    [bookInfoDict setValue:isbn forKey:@"isbn"];
                    
                    
                    [bookInfoDict setValue:category forKey:@"category"];
                   
                    
                    NSString *description=[NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    [bookInfoDict setValue:description forKey:@"description"];
                    
                    
                    NSString *rating=[NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    [bookInfoDict setValue:rating forKey:@"rating"];
                    
                    
                    NSString *title=[NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    [bookInfoDict setValue:title forKey:@"title"];
                    
                    
                    int copies=sqlite3_column_int(statement, 7);
                    [bookInfoDict setValue:[NSNumber numberWithInt:copies] forKey:@"copies"];
                    
                    
                    [arrForFetchingBookInfo addObject:bookInfoDict];
                // 9780596155957
                
            }
            
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"it is in else =%s",sqlite3_errmsg(database));
        }
        sqlite3_close(database);
    }
    return arrForFetchingBookInfo;
}


@end
