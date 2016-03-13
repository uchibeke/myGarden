//
//  ViewControllerNewGarden.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerNewGarden.h"
#import "GloablObjects.h"


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
        [self updateGardenDimensions];
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
    }
    
    if (remove) {
        [[GloablObjects gardenArrayInstance].gardenArray replaceObjectAtIndex:removeIndex withObject:[GloablObjects instance].myGarden];
    }
    
    NSLog(@"global garden updated!");
    NSLog([NSString stringWithFormat:@"%@", [GloablObjects gardenArrayInstance].gardenArray]);
    NSLog([NSString stringWithFormat:@"%d", [GloablObjects gardenArrayInstance].gardenArray.count]);
    
    //loads new view
    [self performSegueWithIdentifier:@"showTabs" sender:self];
    
}


//actually creates the garden object
-(IBAction) goBack: (id) sender {
    [self dismissModalViewControllerAnimated:YES];
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
        [self updateGardenDimensions];
      }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
	
@end
