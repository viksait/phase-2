//
//  libraryViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface libraryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *tabledatasource;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic,retain) NSArray *tabledatasource;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@end

