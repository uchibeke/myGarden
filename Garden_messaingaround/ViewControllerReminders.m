//
//  ViewControllerReminders.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-19.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerReminders.h"
#import "AlarmObject.h"

@interface ViewControllerReminders ()
@end

@implementation ViewControllerReminders

@synthesize tableView;
@synthesize imageView;
@synthesize listOfAlarms;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    self.listOfAlarms = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.listOfAlarms){
        
        return [self.listOfAlarms count];
    }
    else return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"EditAlarm" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditAlarm"])
    {
        //AddEditAlarmViewController *controller = (AddEditAlarmViewController *)segue.destinationViewController;
        //controller.indexOfAlarmToEdit = tableView.indexPathForSelectedRow.row;
        //controller.editMode = YES;
    }
}
//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter * dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"hh:mm a"];
    AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:indexPath.row];
    
    NSString *label = currentAlarm.label;
    BOOL enabled = currentAlarm.enabled;
    NSString *date = [dateReader stringFromDate:currentAlarm.timeToSetOff];
    
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    UISwitch *enabledSwitch;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //
        // Create the cell.
        //
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
        
        //
        // Create the label for the top row of text
        //
        topLabel =
        [[UILabel alloc]
         initWithFrame:
         CGRectMake(14,5,170,40)];
        [cell.contentView addSubview:topLabel];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor blackColor];
        topLabel.highlightedTextColor = [UIColor whiteColor];
        topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]+2];
        
        //
        // Create the label for the top row of text
        //
        bottomLabel =
        [[UILabel alloc]
         initWithFrame:
         CGRectMake(14,30,170,40)];
        [cell.contentView addSubview:bottomLabel];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor blackColor];
        bottomLabel.highlightedTextColor = [UIColor whiteColor];
        bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        
        enabledSwitch = [[UISwitch alloc]
                         initWithFrame:
                         CGRectMake(200,20,170,40)];
        enabledSwitch.tag = indexPath.row;
        [enabledSwitch addTarget:self
                          action:@selector(toggleAlarmEnabledSwitch:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:enabledSwitch];
        
        [enabledSwitch setOn:enabled];
        topLabel.text = date;
        bottomLabel.text = label;
        
    }
    
    return cell;
}

-(void)toggleAlarmEnabledSwitch:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    
    if(mySwitch.isOn == NO)
    {
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = NO;
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
            if ([uid isEqualToString:[NSString stringWithFormat:@"%i",mySwitch.tag]])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    else if(mySwitch.isOn == YES)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = YES;
        if (!localNotification)
            return;
        
        localNotification.repeatInterval = NSCalendarUnitDay;
        [localNotification setFireDate:currentAlarm.timeToSetOff];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        // Setup alert notification
        [localNotification setAlertBody:@"Alarm" ];
        [localNotification setAlertAction:@"Open App"];
        [localNotification setHasAction:YES];
        
        
        NSNumber* uidToStore = [NSNumber numberWithInt:currentAlarm.notificationID];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
        localNotification.userInfo = userInfo;
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:self.listOfAlarms];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
