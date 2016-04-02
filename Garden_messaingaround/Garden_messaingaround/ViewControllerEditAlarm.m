//
//  ViewControllerEditAlarm.m
//  
//
//  Created by Qi Guo on 2016-03-21.
//
//

#import "ViewControllerEditAlarm.h"
#import "ViewControllerReminders.h"
#import "GloablObjects.h"
#import "gardenAlarm.h"

@interface ViewControllerEditAlarm () {
    ViewControllerEditAlarm * reminders;
    NSString * selectedPlant;
    int plantid;
}

@end

@implementation ViewControllerEditAlarm

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.waterSwitch setOn:NO];
    [self.weedSwitch setOn:YES];
    [self.harvestSwitch setOn:NO];
    [self.tableView setHidden:YES];
    [self.timeToSetOff setHidden:NO];
    
    plantid = 0;
    selectedPlant = [[GloablObjects plantDataInstance].plantData getAPlantName:0];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    
    [self.timeToSetOff setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString( @"setHighlightsToday:" );
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature :
                                [UIDatePicker
                                 instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.timeToSetOff];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)waterSw:(id)sender
{
    [self.waterSwitch setOn:YES];
    [self.weedSwitch setOn:NO];
    [self.harvestSwitch setOn:NO];
    [self.tableView setHidden:YES];
    [self.timeToSetOff setHidden:NO];
}

-(IBAction)weedSw:(id)sender
{
    [self.waterSwitch setOn:NO];
    [self.weedSwitch setOn:YES];
    [self.harvestSwitch setOn:NO];
    [self.tableView setHidden:YES];
    [self.timeToSetOff setHidden:NO];
}

-(IBAction)harvestSw:(id)sender
{
    [self.waterSwitch setOn:NO];
    [self.weedSwitch setOn:NO];
    [self.harvestSwitch setOn:YES];
    [self.tableView setHidden:NO];
    [self.timeToSetOff setHidden:YES];
}


-(IBAction)sendNotif:(id)sender
{
    if ([self.weedSwitch isOn]) {
        NSLog(@"send weeding notif");
        UILocalNotification *locNot = [[UILocalNotification alloc] init];
        locNot.fireDate = self.timeToSetOff.date;
        locNot.alertBody = @"Reminder to weed your garden!";
        locNot.timeZone = [NSTimeZone defaultTimeZone];
        locNot.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
        
        gardenAlarm *myAlarm = [[gardenAlarm alloc] init];
        myAlarm.name = @"WEEDING";
        myAlarm.time = locNot.fireDate;
        myAlarm.message = @"Reminder to weed your garden!";
        [[GloablObjects alarmInstance].alarmArray addObject:myAlarm];
    }
    else if ([self.waterSwitch isOn]) {
        NSLog(@"send watering notif");
        UILocalNotification *locNot = [[UILocalNotification alloc] init];
        locNot.fireDate = self.timeToSetOff.date;
        locNot.alertBody = @"Reminder to water your garden!";
        locNot.timeZone = [NSTimeZone defaultTimeZone];
        locNot.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
        
        gardenAlarm *myAlarm = [[gardenAlarm alloc] init];
        myAlarm.name = @"WATERING";
        myAlarm.time = locNot.fireDate;
        myAlarm.message = @"Reminder to water your garden!";
        [[GloablObjects alarmInstance].alarmArray addObject:myAlarm];
        NSLog(@"%d", [[GloablObjects alarmInstance].alarmArray count]);
    }
    else if ([self.harvestSwitch isOn]) {
        NSLog(@"send harvest notif");
        UILocalNotification *locNot = [[UILocalNotification alloc] init];
        NSDate *mydate = [NSDate date];
        double interval = 604800;
        interval *= [[[GloablObjects plantDataInstance].plantData getAPlantTimerCountDown:plantid] integerValue];
        locNot.fireDate = [mydate dateByAddingTimeInterval: interval];
        NSMutableString *message = @"Reminder to harvest your ";
        message = [NSMutableString stringWithFormat:@"%@%@", message, selectedPlant];
        locNot.alertBody = message;
        locNot.timeZone = [NSTimeZone defaultTimeZone];
        locNot.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
        
        gardenAlarm *myAlarm = [[gardenAlarm alloc] init];
        myAlarm.name = @"HARVEST";
        myAlarm.time = locNot.fireDate;
        myAlarm.message = message;
        [[GloablObjects alarmInstance].alarmArray addObject:myAlarm];
        NSLog(@"%d", [[GloablObjects alarmInstance].alarmArray count]);
    }
    
    [self.presentingViewController viewWillAppear:YES];
    [self.presentingViewController viewDidAppear:YES];
    [self dismissModalViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[GloablObjects plantDataInstance].plantData plantsDataArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: @"Cell" ];
    }
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    CGSize itemSize = CGSizeMake(32, 32);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row]] ;
    
    //  tableView.backgroundColor = [UIColor redColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPlant = [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row];
    plantid = indexPath.row;
}

// Size of the cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



-(IBAction) goBack: (id) sender {
    [self dismissModalViewControllerAnimated:YES];
}


@end
