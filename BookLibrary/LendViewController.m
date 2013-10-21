//
//  lendViewController.m
//  SidebarDemo
//0684843285,0943396042,8535902775
//  Created by Goutham on 13/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "lendViewController.h"
#import "DBManager.h"
@interface lendViewController ()

@end

@implementation lendViewController
@synthesize displayDate=_displayDate;
@synthesize datepicker,emailid,name,popoverController,pagetitle,isbn,datasource,flag;
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
  
    self.title=pagetitle;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObject:bar];
    self.displayDate.text=[self twoWeekFromCurrentDay];

}

-(NSString *)twoWeekFromCurrentDay
{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.day = 14;
    NSDate *fireDate =[calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    NSString *dateInStringFormat=[self nsdateToString:fireDate];
    return dateInStringFormat;
    
}

- (IBAction)showActionSheet:(id)sender {
    
    NSString *actionSheetTitle = @"Select Date"; //Action Sheet Title
    
    NSString *other1 = @"3 Week";
    NSString *other2 = @"1 Month";
    NSString *other3 = @"2 Month";
    NSString *other4 = @"Select Specific Date";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:cancelTitle
											   destructiveButtonTitle:nil
													otherButtonTitles:other1, other2, other3,other4, nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
    if ([buttonTitle isEqualToString:@"3 Week"]) {
        
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc]init];
        components.day = 21;
        NSDate *fireDate =[calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
        
        self.displayDate.text=[self nsdateToString:fireDate];
        NSLog(@"%@",fireDate);
        
    }
    if ([buttonTitle isEqualToString:@"1 Month"]) {
        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setMonth:1];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        self.displayDate.text=[self nsdateToString:newDate];
        NSLog(@"%@",newDate);
       
    }
    if ([buttonTitle isEqualToString:@"2 Month"]) {
        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setMonth:2];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        self.displayDate.text=[self nsdateToString:newDate];
        NSLog(@"%@",newDate);
    }
    if ([buttonTitle isEqualToString:@"Select Specific Date"]) {
        menu = [[UIActionSheet alloc] initWithTitle:nil
                                           delegate:self
                                  cancelButtonTitle:nil
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
        UIDatePicker *pickerView = [[UIDatePicker alloc] init];
        pickerView.datePickerMode = UIDatePickerModeDate;
        [pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
        [barItems addObject:doneBtn];
        
        [pickerToolbar setItems:barItems animated:YES];
        [menu addSubview:pickerView];
        [menu addSubview:pickerToolbar];
        [menu showInView:self.view];
        [menu setBounds:CGRectMake(0,0,320,500)];
        CGRect pickerRect = pickerView.bounds;
        pickerRect.origin.y = -40;
        pickerView.bounds = pickerRect;

    }
    
}
-(NSString *)nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateInStringFormat=[dateFormat stringFromDate:date];
    NSLog(@"%@",dateInStringFormat);
    return dateInStringFormat;
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)submit:(id)sender
{
    if (emailid.text.length==0 || self.displayDate.text.length == 0) {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Mandatory fields cannot be left empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alertview show];
    }
    else
    {
        NSDate *currentdate=[NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *str1=[dateFormat stringFromDate:currentdate];
       if(flag == 1)
       {
        BOOL success=[[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:self.displayDate.text status:1];
            if (success==YES) {
            [[DBManager getSharedInstance] updateCopies:isbn copies:-1];
            UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book succesfully lent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
            [alertview show];
            emailid.text=@"";
            self.displayDate.text=@"";
            name.text=@"";
                 [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
            UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Invalid Details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
            [alertview show];
            }
        }
       else
       {
       BOOL success= [[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:self.displayDate.text status:0];
           if (success==YES) {
               [[DBManager getSharedInstance] updateCopies:isbn copies:1];
               UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book succesfully Borrowed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
               [alertview show];
               emailid.text=@"";
               self.displayDate.text=@"";
               name.text=@"";
               
               [self performSelectorInBackground:@selector(fetchAndInsertData) withObject:nil];
               [self.navigationController popViewControllerAnimated:YES];
           }
       }
    }
}

-(IBAction)doneButtonPressed:(UIDatePicker*)sender
{
    [menu dismissWithClickedButtonIndex:0 animated:YES];
    [self.displayDate resignFirstResponder];
   
}
-(void)dateChanged:(UIDatePicker*)sender
{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"YYYY-MM-DD"];
    
    self.displayDate.text=[dateformat stringFromDate:[sender date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)fetchAndInsertData{
    //parse out the json data
    
        
    datasource=[[DBManager getSharedInstance] findDetailsByISBN:isbn];
    if (datasource==nil) {
    NSString *str=[NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@",isbn];
        
    NSURL* jsonURL = [NSURL URLWithString:str];
    NSData* data = [NSData dataWithContentsOfURL:jsonURL];
                
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
    if (json != nil &&
        error == nil)
    {
        NSString *publisher;
        NSString *author;
        NSString *category;
        NSString *description;
        NSString *rating;
        NSString *imgURL;
        NSString *title;
        NSData *imgdata;
        
        
        NSDictionary* items = [json objectForKey:@"items"];
        for(NSDictionary *dict in items)
        {
            title= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"title"] ;
            publisher  = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"publisher"] ;
            author     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"authors"]objectAtIndex:0];
            category   = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"categories"]objectAtIndex:0];
            description= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"description"];
            rating     = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"averageRating"];
            imgURL     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"thumbnail"];
        }
        
        imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:imgdata forKey:isbn];
      [[DBManager getSharedInstance] saveData:isbn title:title author:author publisher:publisher category:category description:description rating:rating copies:1 archive:0];
        
        
    }
}

}

@end
