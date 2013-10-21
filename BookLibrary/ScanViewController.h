//
//  scanViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "DBManager.h"

@interface ScanViewController : UIViewController<ZBarReaderDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UIImageView *resultImage;
    UITextField *resultText;
    NSString *publisher;
    NSString *author;
    NSString *category;
    NSString *description;
    NSString *rating;
    NSString *imgURL;
    NSString *title;
    NSData *imgdata;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextField *resultText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *camerabutton;
@property (nonatomic,assign) NSInteger bookexists;


@end
