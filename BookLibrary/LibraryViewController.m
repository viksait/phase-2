//
//  libraryViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "libraryViewController.h"
#import "SWRevealViewController.h"
#import "booklistViewController.h"
#import "DBManager.h"
@interface libraryViewController ()

@end

@implementation libraryViewController
@synthesize tabledatasource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
       [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
          [self.revealViewController performSelector:@selector(revealToggle:) withObject:self];
      
    }
    
    self.title = @"My Library";
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    self.view.backgroundColor = [UIColor clearColor];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.tabledatasource=@[@"Action",@"Adventure",@"Fiction",@"Psychology",@"Spiritual",@"Computers",@"Cooking"];
     //self.tableview.backgroundColor =[UIColor grayColor];
    //self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"gingham.png"]];
	// Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tabledatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text=[self.tabledatasource objectAtIndex:indexPath.row];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Categories";
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        NSIndexPath *indexPath=[self.tableview indexPathForSelectedRow];
        booklistViewController *booklist=segue.destinationViewController;
        booklist.category=[self.tabledatasource objectAtIndex:indexPath.row];
        booklist.tabledatasource=[[DBManager getSharedInstance] findDetailForCategory:booklist.category ];
        
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *index=[self.tableview indexPathForSelectedRow];
    if(index!=nil)
    {
        [self.tableview deselectRowAtIndexPath:index animated:YES];
    }
    
}

@end
