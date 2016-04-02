//
//  AppDelegate.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "AppDelegate.h"
#import "GloablObjects.h"
#import "gardenAlarm.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
//    rootViewController.alarmGoingOff = YES;
//    self.window.rootViewController = rootViewController;
//    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(124/255.0f) green:(186/255.0f) blue:(37/255.0f) alpha:(1.0f)]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(124/255.0f) green:(186/255.0f) blue:(37/255.0f) alpha:(1.0f)]];
//    [self.window setTintColor:[UIColor colorWithRed:(242/255.0f) green:(209/255.0f) blue:(18/255.0f) alpha:(1.0f)]];
     [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
//    [[UITableViewCell appearance] setTextColor:[UIColor whiteColor]];

    //Prevents screen from locking
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif)
    {
        [self setupWindow];
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSString *fir = [NSDateFormatter localizedStringFromDate:notification.fireDate
                                                   dateStyle:NSDateFormatterShortStyle
                                                   timeStyle:NSDateFormatterFullStyle];
    
    for(gardenAlarm *notificat in [GloablObjects alarmInstance].alarmArray){
        if ([fir isEqualToString:[NSDateFormatter localizedStringFromDate:notificat.time
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterFullStyle]]) {
            if (!notification.repeatInterval) {
                // delete this notification
                [[GloablObjects alarmInstance].alarmArray removeObject:notificat];
            }
        }
    }
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:notification.alertTitle    message:notification.alertBody
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [notificationAlert show];
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
@end
