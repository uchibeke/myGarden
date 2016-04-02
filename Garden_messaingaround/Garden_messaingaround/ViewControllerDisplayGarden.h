//
//  ViewControllerDisplayGarden.h
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GardenObject.h"
#import "PlantObject.h"

@interface ViewControllerDisplayGarden : UIViewController

@property GardenObject * garden;
@property NSInteger brushIndex;
@property NSInteger clickedIndex;

@property IBOutlet UICollectionView *collectionView;
@property IBOutlet UITableView *tableView;
@property IBOutlet UIImageView * shot;
@property IBOutlet UIButton * takePhoto;

@property UIImageView *backgroundimgview;

@property int alert;
@property bool delmode;

-(NSMutableDictionary *)getAPlantObject: (NSString *) thePlantName;
-(bool)checkfoes:(int) index;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void) notifyUser: (NSString *) notificationMsg;

-(IBAction) removeTool: (id) sender;
-(UIImage *)capture;
-(IBAction) takePhoto: (id) sender;
-(IBAction) facebookShareGarden: (id) sender;
-(IBAction) twitterShareGarden: (id) sender;
-(IBAction) modifyGarden: (id) sender;
-(IBAction) goAllGardens: (id) sender;

-(void) updateUserDefaults;
-(void) getFromUserDefaults;

@end
