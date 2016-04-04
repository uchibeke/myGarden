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

@interface ViewControllerNewGarden ()

@end

@implementation ViewControllerNewGarden

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sets title bar and bkg
    [self setTitle:@"Create New Garden"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    
    //checks if modifying or creating and sets field appropriately
    if ([GloablObjects instance].myGarden != nil) {
        self.heightDisp.text = [NSString stringWithFormat:@"%d", (int)[GloablObjects instance].myGarden.height];
        self.widthDisp.text = [NSString stringWithFormat:@"%d", (int)[GloablObjects instance].myGarden.width];
        self.name.text = [GloablObjects instance].myGarden.name;
        self.width.value = [GloablObjects instance].myGarden.width;
        self.height.value = [GloablObjects instance].myGarden.height;
        [self.createBtn setTitle: @"Modify Garden" forState:UIControlStateNormal];
        self.modifying = true;
    } else {
        [self.createBtn setTitle: @"Create Garden" forState:UIControlStateNormal];
        self.modifying = false;
        self.width.value = 1;
        self.height.value = 1;
    }
    
    //sets our height and width varibles to the stepper value
    self.h = self.height.value;
    self.w = self.self.width.value;
}


// Hide the keyboard when losing focus on the UITextField
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.name isFirstResponder] && [touch view] != self.name) {
        [self.name resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void) updateGardenDimensions {
    GardenObject* oldGarden = [GloablObjects instance].myGarden;
    
    if (!self.modifying) {
        [GloablObjects instance].myGarden = [[GardenObject alloc] init];
        [[GloablObjects instance].myGarden allocateTable:self.h withWidth:self.w];
        [[GloablObjects instance].myGarden setName:self.name.text];
    } else {
        [[GloablObjects instance].myGarden setName:self.name.text];
        
        //width adjustment
        NSInteger oldWidth = [GloablObjects instance].myGarden.width;
        if ((oldWidth - self.w) >= 0) {
            NSInteger loops = oldWidth-self.w;
            
            for (int j=0; j < loops; j++) {
                //for delete a collumn
                for (int i=0; i<[GloablObjects instance].myGarden.gardenArr2d.count; i+=oldWidth-1){
                    [[GloablObjects instance].myGarden.gardenArr2d removeObjectAtIndex:i];
                }
                oldWidth--;
            }
            [GloablObjects instance].myGarden.width = [self.widthDisp.text intValue];
        } else {
            NSInteger loops = self.w-oldWidth;
            
            for (int j=0; j < loops; j++) {
                //for delete a collumn
                for (int i=0; i<[GloablObjects instance].myGarden.gardenArr2d.count; i+=oldWidth+1){
                    PlantObject *myPlant = [PlantObject new];
                    myPlant.name = @"";
                    [[GloablObjects instance].myGarden.gardenArr2d insertObject:myPlant atIndex:i];
                }
                oldWidth++;
            }
            [GloablObjects instance].myGarden.width = [self.widthDisp.text intValue];
        }
        
        
        //height adjustment
        NSInteger oldHeight = [GloablObjects instance].myGarden.height;
        if ((oldHeight - self.h) >= 0) {
            NSInteger toDelFromEnd = (oldHeight - self.h)*[GloablObjects instance].myGarden.width;
            for (int j=0;j<toDelFromEnd; j++) {
                NSInteger temp = [GloablObjects instance].myGarden.gardenArr2d.count-1;
                [[GloablObjects instance].myGarden.gardenArr2d removeObjectAtIndex:temp];
                oldHeight--;
            }
            [GloablObjects instance].myGarden.height = [self.heightDisp.text intValue];
        } else {
            NSInteger toAddToEnd = (self.h - oldHeight)*self.w;
            for (int j=0;j<toAddToEnd; j++) {
                NSInteger temp = [GloablObjects instance].myGarden.gardenArr2d.count;
                PlantObject *myPlant = [PlantObject new];
                myPlant.name = @"";
                [[GloablObjects instance].myGarden.gardenArr2d insertObject:myPlant atIndex:temp];
                oldHeight++;
            }
            [GloablObjects instance].myGarden.height = [self.heightDisp.text intValue];
        }
    }
    
    //required for updating entries in the garden
    //logic: removes old entry by object comparison
    
    //does so by looping through all entries in garden array
    //and making note of the entry with the name we want to replace
    Boolean remove = false;
    int removeIndex = 0;
    if (self.modifying) {
        int index = 0;
        GardenObject *item;
        for (item in [GloablObjects gardenArrayInstance].gardenArray) {
            if (item == oldGarden) {
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
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.presentingViewController viewWillAppear:YES];
        [self.presentingViewController viewDidAppear:YES];
        [self updateGardenDimensions];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



//actually creates the garden object
-(IBAction) createGarden: (id) sender {
    if ((self.modifying && ([GloablObjects instance].myGarden.width - self.w) > 0) || (self.modifying &&([GloablObjects instance].myGarden.height - self.h) > 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                        message:@"You are about to shrink your garden! This will delete plants that are outisde of the new dimensions. Are you sure you to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue",nil];
        //image in alertview
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *loc = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"scaredTomato_100tall.png"]];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:loc];
        [image setImage:img];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [alert setValue:image forKey:@"accessoryView"];
        }else{
            [alert addSubview:image];
        }
        
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
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(IBAction) goBack: (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) widthModfier: (UIStepper*) sender {
    self.w = (NSInteger)sender.value;
    self.widthDisp.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

-(IBAction) heightModfier: (UIStepper*) sender {
    self.h = (NSInteger)sender.value;
    self.heightDisp.text = [NSString stringWithFormat:@"%d", (int)sender.value];
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
    
    if (gardens != nil && gardenNames != nil) {
        int i = 0;
        for (NSMutableArray * gard in gardens) {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
	
@end
