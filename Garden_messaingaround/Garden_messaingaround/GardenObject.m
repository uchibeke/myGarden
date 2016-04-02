//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "GardenObject.h"

@implementation GardenObject

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
}


@end
