//
//  FirstViewController.h
//  booklibrary
//
//  Created by Goutham on 10/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface FirstViewController : UIViewController
{
    NSData *downloaddata;
    NSString *databasePath;
}
@property(strong, nonatomic) NSData *downloaddata;
@property(nonatomic,retain) IBOutlet UIImageView *imgview;
@end
