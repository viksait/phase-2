//
//  960-425-059-0historyViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface historyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    int flag;
    MFMailComposeViewController *mailComposer;
    UIAlertView *alert;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *remind;
@property (nonatomic,retain) IBOutlet UISegmentedControl *seg;
@property (nonatomic,retain) NSMutableArray *lentbooks;
@property (nonatomic,retain) NSMutableArray *borrowedbooks;
@property (nonatomic,retain) NSMutableArray *completed;
@property (nonatomic,retain) NSMutableArray *SelectedIndexes;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) MFMailComposeViewController *mailComposer;
-(IBAction)sendMail:(id)sender;

@end
