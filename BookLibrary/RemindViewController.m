//
//  RemindViewController.m
//  BookLibrary
//
//  Created by Goutham on 17/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import "RemindViewController.h"

@interface RemindViewController ()

@end

@implementation RemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - mail compose delegate
     -(void)mailComposeController:(MFMailComposeViewController *)controller
             didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
                 if (result) {
                     NSLog(@"Result : %d",result);
                 }
                 if (error) {
                     NSLog(@"Error : %@",error);
                 }
                 [self dismissModalViewControllerAnimated:YES];
                 
             }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
