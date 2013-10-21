//
//  booklistViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface booklistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,DLStarRatingDelegate>
{
    NSMutableArray *tabledatasource;
    NSMutableArray *results;
    NSString *category;
    DLStarRatingControl *customnumberofstars;
}
@property (nonatomic,retain) NSMutableArray *tabledatasource;
@property (nonatomic,retain) NSMutableArray *results;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) NSString *category;
@end
