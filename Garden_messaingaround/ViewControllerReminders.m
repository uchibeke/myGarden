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
    [self getFromAlarmUserDefaults];
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
    cell.textLabel.text = message;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", [NSDateFormatter localizedStringFromDate:myAlaram.time
                                                                                                   dateStyle:NSDateFormatterShortStyle
                                                                                                   timeStyle:NSDateFormatterFullStyle], @""];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    NSString * imgName = [NSString stringWithFormat:@"reminderWhite"];
    cell.imageView.image = [UIImage imageNamed:imgName];
    
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
    gardenAlarm *myAlarm = [[GloablObjects alarmInstance].alarmArray objectAtIndex:indexPath.row];
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification *notification in notificationArray){
        NSString *fir = [NSDateFormatter localizedStringFromDate:notification.fireDate
                                             dateStyle:NSDateFormatterShortStyle
                                             timeStyle:NSDateFormatterFullStyle];
        NSString *sec = [NSDateFormatter localizedStringFromDate:myAlarm.time
                                             dateStyle:NSDateFormatterShortStyle
                                             timeStyle:NSDateFormatterFullStyle];

        if ([fir isEqualToString:sec]) {
            // delete this notification
            NSLog(@"found");
            [[UIApplication sharedApplication] cancelLocalNotification:notification] ;
        }
    }
    [[GloablObjects alarmInstance].alarmArray removeObjectAtIndex:indexPath.row ];
    [self.tableView reloadData];
    [self updateAlarmUserDefaults];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"data reload");
    [self.tableView reloadData];
    [self updateAlarmUserDefaults];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"data reload");
    [self.tableView reloadData];
    [self updateAlarmUserDefaults];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void) updateAlarmUserDefaults {
    NSMutableArray *alarmNames = [NSMutableArray arrayWithCapacity:[[GloablObjects alarmInstance].alarmArray count]];
    NSMutableArray *alarmTimes = [NSMutableArray arrayWithCapacity:[[GloablObjects alarmInstance].alarmArray count]];
    NSMutableArray *alarmMessages = [NSMutableArray arrayWithCapacity:[[GloablObjects alarmInstance].alarmArray count]];
    
    for (gardenAlarm * alarm in [GloablObjects alarmInstance].alarmArray) {
        [alarmNames addObject:alarm.name];
        [alarmTimes addObject:alarm.time];
        [alarmMessages addObject:alarm.message];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:alarmNames forKey:@"alarmNames"];
    [userDefaults setObject:alarmTimes forKey:@"alarmTimes"];
    [userDefaults setObject:alarmMessages forKey:@"alarmMessages"];
    [userDefaults synchronize];
}

-(void) getFromAlarmUserDefaults {
    //wipes all gardens, will be reloaded from user defaults
    [GloablObjects alarmInstance].alarmArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *alarmNames = [userDefaults objectForKey:@"alarmNames"];
    NSMutableArray *alarmTimes = [userDefaults objectForKey:@"alarmTimes"];
    NSMutableArray *alarmMessages = [userDefaults objectForKey:@"alarmMessages"];
    
    if (alarmMessages == nil || alarmTimes == nil) {
        NSLog(@"no alarms found");
    } else {
        int i = 0;
        for (NSString * alarm in alarmNames) {
            NSLog(@"loading...");
            gardenAlarm *alarm = [[gardenAlarm alloc] init];
            alarm.name = alarmNames[i];
            alarm.time = alarmTimes[i];
            alarm.message = alarmMessages[i];
            
            [[GloablObjects alarmInstance].alarmArray addObject:alarm];
            i+=1;
        }
    }
    
}


-(IBAction) goAllGardens: (id) sender {
    NSLog(@"clicked");
    [self.navigationController.presentingViewController.presentingViewController viewWillAppear:YES];
    [self.navigationController.presentingViewController.presentingViewController viewDidAppear:YES];
    if (self.navigationController.presentingViewController.presentingViewController) {
        [self.navigationController.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
