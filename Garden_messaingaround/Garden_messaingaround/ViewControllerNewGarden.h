//
//  ViewControllerNewGarden.h
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GardenObject.h"

@interface ViewControllerNewGarden : UIViewController

@property GardenObject *gard;

@property IBOutlet UITextField* name;
@property IBOutlet UIStepper* width;
@property IBOutlet UIStepper* height;
@property IBOutlet UILabel* widthDisp;
@property IBOutlet UILabel* heightDisp;
@property IBOutlet UIButton * createBtn;

@property NSInteger w;
@property NSInteger h;

@property Boolean modifying;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void) updateGardenDimensions;
-(IBAction) goBack: (id) sender;
-(IBAction) widthModfier: (UIStepper*) sender;
-(IBAction) heightModfier: (UIStepper*) sender;
-(IBAction) createGarden: (id) sender;
-(void) updateUserDefaults;
-(void) getFromUserDefaults;

@end
