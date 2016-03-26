//
//  ViewControllerNewGarden.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerNewGarden.h"
#import "GloablObjects.h"
#import "GardenObject.h"

@interface ViewControllerNewGarden () {

    IBOutlet UITextField* name;
    IBOutlet UIStepper* width;
    IBOutlet UIStepper* height;
    IBOutlet UILabel* widthDisp;
    IBOutlet UILabel* heightDisp;
    IBOutlet UIButton * createBtn;
}

@property NSInteger w;
@property NSInteger h;

@property Boolean modifying;

@end

@implementation ViewControllerNewGarden

- (void)viewDidLoad {
    [super viewDidLoad];
    //sets title bar
    [self setTitle:@"Create New Garden"];
    if ([GloablObjects instance].myGarden != nil) {
        heightDisp.text = [NSString stringWithFormat:@"%d", (int)[GloablObjects instance].myGarden.height];
        widthDisp.text = [NSString stringWithFormat:@"%d", (int)[GloablObjects instance].myGarden.width];
        name.text = [GloablObjects instance].myGarden.name;
        width.value = [GloablObjects instance].myGarden.width;
        height.value = [GloablObjects instance].myGarden.height;
        [createBtn setTitle: @"Modify Garden" forState:UIControlStateNormal];
        self.modifying = true;
    } else {
        [createBtn setTitle: @"Create Garden" forState:UIControlStateNormal];
        self.modifying = false;
        width.value = 1;
        height.value = 1;
    }
    
    self.h = height.value;
    self.w = width.value;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-texture-background.jpg"]];
//    brown-texture-background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
}


// Hide the keyboard when losing focus on the UITextField
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([name isFirstResponder] && [touch view] != name) {
        [name resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(IBAction) widthModfier: (UIStepper*) sender {
    self.w = (NSInteger)sender.value;
    widthDisp.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

-(IBAction) heightModfier: (UIStepper*) sender {
    self.h = (NSInteger)sender.value;
    heightDisp.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        [self.presentingViewController viewWillAppear:YES];
        [self.presentingViewController viewDidAppear:YES];
        [self updateGardenDimensions];
        [self dismissModalViewControllerAnimated:YES];
    }
}


-(void) updateGardenDimensions {
    NSLog(@"deleting...");
    
    GardenObject* oldGarden = [GloablObjects instance].myGarden;
    
    if (!self.modifying) {
        [GloablObjects instance].myGarden = [[GardenObject alloc] init];
        [[GloablObjects instance].myGarden allocateTable:self.h withWidth:self.w];
        [[GloablObjects instance].myGarden setName:name.text];
    } else {
        [[GloablObjects instance].myGarden setName:name.text];
        //wdith adjustment
        int oldWidth = [GloablObjects instance].myGarden.getWidth;
        if ((oldWidth - self.w) >= 0) {
            int loops = oldWidth-self.w;
            
            for (int j=0; j < loops; j++) {
                //for delete a collumn
                for (int i=0; i<[GloablObjects instance].myGarden.gardenArr2d.count; i+=oldWidth-1){
                    [[GloablObjects instance].myGarden.gardenArr2d removeObjectAtIndex:i];
                }
                oldWidth--;
            }
            //[GloablObjects instance].myGarden.width = oldWidth;
            [GloablObjects instance].myGarden.width = [widthDisp.text intValue];
        } else {
            int loops = self.w-oldWidth;
            
            for (int j=0; j < loops; j++) {
                //for delete a collumn
                for (int i=0; i<[GloablObjects instance].myGarden.gardenArr2d.count; i+=oldWidth+1){
                    PlantObject *myPlant = [PlantObject new];
                    myPlant.name = @"";
                    [[GloablObjects instance].myGarden.gardenArr2d insertObject:myPlant atIndex:i];
                }
                oldWidth++;
            }
            [GloablObjects instance].myGarden.width = [widthDisp.text intValue];
        }
        
        
        //hieght adjustment
        int oldHeight = [GloablObjects instance].myGarden.getHeight;
        if ((oldHeight - self.h) >= 0) {
            int toDelFromEnd = (oldHeight - self.h)*[GloablObjects instance].myGarden.getWidth;
            for (int j=0;j<toDelFromEnd; j++) {
                int temp = [GloablObjects instance].myGarden.gardenArr2d.count-1;
                [[GloablObjects instance].myGarden.gardenArr2d removeObjectAtIndex:temp];
                oldHeight--;
            }
            [GloablObjects instance].myGarden.height = [heightDisp.text intValue];
        } else {
            int toAddToEnd = (self.h - oldHeight)*self.w;
            for (int j=0;j<toAddToEnd; j++) {
                int temp = [GloablObjects instance].myGarden.gardenArr2d.count;
                PlantObject *myPlant = [PlantObject new];
                myPlant.name = @"";
                [[GloablObjects instance].myGarden.gardenArr2d insertObject:myPlant atIndex:temp];
                oldHeight++;
            }
            [GloablObjects instance].myGarden.height = [heightDisp.text intValue];
        }
    }
    
    //required for updating entries in the garden
    //logic: removes old entry by object comparison
    
    //dos soby looping through all entries in garden array
    //and makeing note of the entry with the name we want to replace
    Boolean remove = false;
    int removeIndex = 0;
    if (self.modifying) {
        int index = 0;
        GardenObject *item;
        for (item in [GloablObjects gardenArrayInstance].gardenArray) {
            if (item == oldGarden) {
                NSLog(@"found!");
                removeIndex = index;
                remove = true;
            }
            index++;
        }
    } else {
        [[GloablObjects gardenArrayInstance].gardenArray addObject:[GloablObjects instance].myGarden ];
        [self updateUserDefaults];
    }
    
    if (remove) {
        [[GloablObjects gardenArrayInstance].gardenArray replaceObjectAtIndex:removeIndex withObject:[GloablObjects instance].myGarden];
        [self updateUserDefaults];
    }
    
    NSLog(@"global garden updated!");
    
  
}


//actually creates the garden object
-(IBAction) goBack: (id) sender {
    [self dismissModalViewControllerAnimated:YES];
}


-(void) updateUserDefaults {
    NSMutableArray *gardens = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenNames = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenWidth = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenHeight = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    
    for (GardenObject * gard in [GloablObjects gardenArrayInstance].gardenArray) {
        [gardenNames addObject:gard.name];
        NSNumber *w = [NSNumber numberWithInteger:gard.width];
        NSNumber *h = [NSNumber numberWithInteger:gard.height];
        [gardenHeight addObject:w];
        [gardenWidth addObject:h];
        NSLog(@"%d", [gardenHeight[0] integerValue]);
        NSMutableArray *garden = [NSMutableArray arrayWithCapacity:[gard.gardenArr2d count]];
        for (PlantObject * plant in gard.gardenArr2d) {
            if ([ plant.name isEqualToString:@"" ]) {
                [garden addObject:@""];
            } else {
                [garden addObject:plant.name];
            }
        }
        [gardens addObject:garden];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:gardens forKey:@"gardens"];
    [userDefaults setObject:gardenNames forKey:@"gardenNames"];
    [userDefaults setObject:gardenWidth forKey:@"gardenWidth"];
    [userDefaults setObject:gardenHeight forKey:@"gardenHeight"];
    [userDefaults synchronize];
}

-(void) getFromUserDefaults {
    //wipes all gardens, will be reloaded from user defaults
    [GloablObjects gardenArrayInstance].gardenArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gardens = [userDefaults objectForKey:@"gardens"];
    NSMutableArray *gardenNames = [userDefaults objectForKey:@"gardenNames"];
    NSMutableArray *gardenWidth = [userDefaults objectForKey:@"gardenWidth"];
    NSMutableArray *gardenHeight = [userDefaults objectForKey:@"gardenHeight"];
    
    if (gardens == nil || gardenNames == nil) {
        NSLog(@"gardens not found. creating new instance.");
    } else {
        NSLog(@"gardens found. loading from file.");
        int i = 0;
        for (NSMutableArray * gard in gardens) {
            NSLog(@"help");
            GardenObject * newGarden = [[GardenObject alloc] init];
            [newGarden allocateTable:[gardenWidth[i] integerValue] withWidth:[gardenHeight[i] integerValue]];
            [newGarden setName:gardenNames[i]];
            
            int j = 0;
            for (NSString * plant in gard) {
                PlantObject * newPlant = [[PlantObject alloc] init];
                if ([plant isEqualToString:@"" ]) {
                    newPlant.name = @"";
                } else {
                    newPlant.name = plant;
                }
                [newGarden.gardenArr2d replaceObjectAtIndex:j withObject:newPlant];
                j+=1;
            }
            [[GloablObjects gardenArrayInstance].gardenArray addObject:newGarden];
            i+=1;
        }
    }
    
}

//actually creates the garden object
-(IBAction) createGarden: (id) sender {
    NSLog(@"call");
    //creates and allocates new garden object
    //currently uses a default of 10 x 10
    
    NSLog(@"updating garden...");
    
    if ((self.modifying && ([GloablObjects instance].myGarden.getWidth - self.w) > 0) || (self.modifying &&([GloablObjects instance].myGarden.getHeight - self.h) > 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                        message:@"you are about to shrink your garden! this will delete plants that are outisde of the new dimensions. are you sure you to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue",nil];
        [alert show];
    } else {
        if (!self.modifying) {
            [self updateGardenDimensions];
            //loads new view
            [self performSegueWithIdentifier:@"showTabs" sender:self];
        } else {
            [self.presentingViewController viewWillAppear:YES];
            [self.presentingViewController viewDidAppear:YES];
            [self updateGardenDimensions];
            [self dismissModalViewControllerAnimated:YES];
        }
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
	
@end
