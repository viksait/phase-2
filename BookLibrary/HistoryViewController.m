//
//  historyViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "historyViewController.h"
#import "SWRevealViewController.h"
#import "tablecell.h"
#import "DBManager.h"
@interface historyViewController ()

@end

@implementation historyViewController

@synthesize seg,lentbooks,borrowedbooks,completed,tableview,remind,mailComposer,SelectedIndexes;
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
    self.title = @"History";
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	// Do any additional setup after loading the view.
    SelectedIndexes=[[NSMutableArray alloc] init];
    self.lentbooks=[[DBManager getSharedInstance] getTransactionsByStatus:1];
    self.tableview.tableFooterView=[[UIView alloc] init];
        
}


-(NSString*)differenceBetDays:(NSString *)stringdate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date1=[formatter dateFromString:stringdate];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secondsBetTwoDates=[date1 timeIntervalSinceDate:currentDate];
    int noOfDaysLeft=(secondsBetTwoDates/86400);
    NSString *str=[NSString stringWithFormat:@"%d days left",noOfDaysLeft];
    return str;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (flag) {
        case 1:
            return [borrowedbooks count];
            break;
        case 2:
            return [completed count];
            break;
        default:
            return [lentbooks count];
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellidentifier=[NSString stringWithFormat:@"cell%d",flag];
    tablecell *cell = [tableView
                       dequeueReusableCellWithIdentifier:cellidentifier];
   
    
    if (cell == nil)
    {
        cell = [[tablecell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellidentifier];
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    switch (flag) {
        case 1:
        {
        
            NSString *isbn= [[borrowedbooks objectAtIndex:indexPath.row] objectForKey:@"isbn"];
            NSString *duedate =[[borrowedbooks objectAtIndex:indexPath.row] objectForKey:@"duedate"];
            cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:isbn]];
            cell.nameLabel.text=[[borrowedbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"];
            cell.datelbl.text= [self differenceBetDays:duedate];
            cell.titlelbl.text=[[DBManager getSharedInstance] getBookNameByISBN:isbn];
        }
            break;
        case 2:
        {
            NSString *isbn= [[completed objectAtIndex:indexPath.row] objectForKey:@"isbn"];
            NSString *issuedate =[[completed objectAtIndex:indexPath.row] objectForKey:@"issuedate"];
            NSString *returndate =[[completed objectAtIndex:indexPath.row] objectForKey:@"returndate"];
            cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:isbn]];
            cell.nameLabel.text=[[completed objectAtIndex:indexPath.row] objectForKey:@"emailid"];
            cell.datelbl.text= [NSString stringWithFormat:@"%@ - %@",issuedate,returndate];
            cell.titlelbl.text=[[DBManager getSharedInstance] getBookNameByISBN:isbn];
        }
            break;
        default:
        
            if ([SelectedIndexes containsObject:[NSNumber numberWithInt:indexPath.row]]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            
            NSString *isbn= [[self.lentbooks objectAtIndex:indexPath.row] objectForKey:@"isbn"];
            
            NSString *duedate =[[self.lentbooks objectAtIndex:indexPath.row] objectForKey:@"duedate"];
            NSLog(@"viks %@",duedate);
                       
            cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:isbn]];
            cell.nameLabel.text=[[self.lentbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"];
            cell.datelbl.text= [self differenceBetDays:duedate];
            //NSLog(@"vvv %@",cell.datelbl.text);
            cell.titlelbl.text=[[DBManager getSharedInstance] getBookNameByISBN:isbn];
            break;
    }
    return cell;
}




  

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (flag==0) {
        
    
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
        
            if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
                
            [SelectedIndexes removeObject:[[lentbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"]];
                
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [SelectedIndexes addObject:[[lentbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"]];
                
                
            }
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}


-(IBAction)segControlClicked:(id)sender
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            flag=0;
            break;
        case 1:
            flag=1;
            if (borrowedbooks==nil) {
                
                 self.borrowedbooks=[[DBManager getSharedInstance] getTransactionsByStatus:0];
            }
           
            break;
        case 2:
            flag=2;
            if (completed==nil) {
                
                self.completed=[[DBManager getSharedInstance] completedTransactions];
            }
            break;
        default:
            break;
    }
    [tableview reloadData];
}
-(void)sendMail:(id)sender{
    //if selected indexes count not zero
    
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setTitle:@"Send Mail"];
    [mailComposer setSubject:@"Return Book"];
    [mailComposer setMessageBody:@"Please Return My Book Immediately as you've crossed due date" isHTML:NO];
    [mailComposer setToRecipients:SelectedIndexes];
    [self presentViewController:mailComposer animated:YES completion:nil];
   
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
           
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: cancelled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultSaved:
            
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
           
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        default:
            
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: not sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
    
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
