//
//  RemindViewController.h
//  BookLibrary
//
//  Created by Goutham on 17/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface RemindViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
}
-(IBAction)sendMail:(id)sender;
@end
