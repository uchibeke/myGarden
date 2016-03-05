//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "GardenObject.h"

@implementation GardenObject
@synthesize width;
@synthesize height;

-(void)setWidth:(NSInteger) w {
    width = w;
}

-(NSInteger)getWidth {
    return width ;
}

//We might wanna edit this. setHeight is assummed to already exist and we can just call it
//thus [somePerson setHeight:numerToAssign] . This is true for both setWidth too.

//See https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html

- (void)setHeight:(NSInteger ) h {
    height = (NSInteger ) h;
}

- (NSInteger)getHeight {
    return height;
}

-(void)  allocateTable:(NSInteger)h withWidth:(NSInteger) w {
    //sets width and height for table view
    [self setHeight: h];
    [self setWidth: w];
    
    //creates a dummy plants in order to set up/test 2d array
    PlantObject *myPlant = [PlantObject new];
    myPlant.name = @"";
    
    //adding objects to garden
    self.gardenArr2d = [NSMutableArray new];
    for (int i = 0; i < h*w; i++) {
        [self.gardenArr2d addObject:myPlant];
    }
    
    //print a dummy plant
    PlantObject *myPlanty = self.gardenArr2d[0];
    NSLog(myPlanty.name);

}


@end
