//
//  bookdetailsViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface bookdetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DLStarRatingDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *outputarray;
    NSMutableArray *tabledatasource;
    NSArray *headers;
     DLStarRatingControl *customnumberofstars;
    int flag;
    UIActionSheet *action;
}
@property (nonatomic,retain) NSMutableArray *outputarray;
@property (nonatomic,retain) NSMutableArray *tabledatasource;
@property (nonatomic,strong) IBOutlet UIPickerView *pickerview;
@property (nonatomic,retain) NSMutableArray *pickersource;
@property (nonatomic,assign) int flag;
@end
