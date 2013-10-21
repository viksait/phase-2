//
//  FirstViewController.m
//  booklibrary
//
//  Created by Goutham on 10/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//



#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize downloaddata,imgview;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL* jsonURL = [NSURL URLWithString:@"https://www.googleapis.com/books/v1/volumes?q=isbn:0735619670"];
    
   // NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:jsonURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
   // _downloadData = [[NSMutableData dataWithCapacity:512] retain];
    
  //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
  NSString *localPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"library.sqlite"];
    NSLog(@"goutham");
    NSError *error;
	databasePath = [documentsDir stringByAppendingPathComponent:@"library.sqlite"];

    NSFileManager *filem=[NSFileManager defaultManager];
    BOOL success=[filem fileExistsAtPath:databasePath];
    if (success) {
        NSLog(@"found");
    }
    else
    {
        [filem copyItemAtPath:localPath toPath:databasePath error:&error];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        jsonURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    NSString *img;
    NSArray* latestLoans = [json objectForKey:@"items"]; //2
    for(NSDictionary *dict in latestLoans)
    {
     img=[[[dict objectForKey:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"thumbnail"];
    }
    NSData *imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
    UIImage *image=[UIImage imageWithData:imgdata];
    imgview.image=image;
    [self saveData];
}
- (void) saveData
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    //const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
       // NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO books (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", name.text, address.text, phone.text];
     
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO BOOKS VALUES (1,1,1,1,1,1,1,1,1)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
               NSLog(@"hello");
        } else {
             NSLog( @"Error: %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //[downloaddata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //[downloaddata appendData:data];

}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    downloaddata = nil;
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* jsonError = nil;
    
    NSDictionary* jsonDict = nil; // your data will come out as a NSDictionry from the parser
    jsonDict = [NSJSONSerialization JSONObjectWithData:downloaddata options:NSJSONReadingMutableLeaves  error:&jsonError];
    
    
    if ( nil != jsonError ) {
        // do something about the error
        
        return;
    }
    
    downloaddata = nil;
    
    // now do whatever you want with your data in the 'jsonDict'
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
