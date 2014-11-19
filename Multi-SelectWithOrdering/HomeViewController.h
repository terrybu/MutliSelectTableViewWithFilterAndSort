//
//  HomeViewController.h
//  Multi-SelectWithOrdering
//
//  Created by Aditya Narayan on 11/13/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)segCtrlAction:(id)sender;

- (IBAction)doneAction:(id)sender;


@end
