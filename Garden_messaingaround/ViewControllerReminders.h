//
//  ViewControllerReminders.h
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-19.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ViewControllerReminders : UIViewController
{
    UITableView *tableView;
    UIImageView *imageView;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *listOfAlarms;

@end
