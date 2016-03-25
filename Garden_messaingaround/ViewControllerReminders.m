//
//  ViewControllerReminders.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-19.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerReminders.h"
#import "GloablObjects.h"
#import "gardenAlarm.h"

@interface ViewControllerReminders ()
@end

@implementation ViewControllerReminders

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[GloablObjects alarmInstance].alarmArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    
    if ( cell == nil )
    {
        cell = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"Cell" ];
    }
    
    //Can access the array with the below.  But need to first put things in the array.
    gardenAlarm *myAlaram = [GloablObjects alarmInstance].alarmArray[indexPath.row];
    
    NSMutableString *message = myAlaram.name;
    message = [NSMutableString stringWithFormat:@"%@%@", message, @" - "];
    message = [NSMutableString stringWithFormat:@"%@%@", message, myAlaram.message];
    message = [NSMutableString stringWithFormat:@"%@%@", message, @" - "];
    message = [NSMutableString stringWithFormat:@"%@%@", message, [NSDateFormatter localizedStringFromDate:myAlaram.time
                                                                                                 dateStyle:NSDateFormatterShortStyle
                                                                                                 timeStyle:NSDateFormatterFullStyle]];
    
    cell.textLabel.text = message;
    //cell.textLabel.text =
    //cell.imageView.image =
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    [[GloablObjects alarmInstance].alarmArray removeObjectAtIndex:indexPath.row ];
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"data reload");
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"data reload");
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
