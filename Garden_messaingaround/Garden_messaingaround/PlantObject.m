//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "PlantObject.h"

@implementation PlantObject



// I got plant json data from https://raw.githubusercontent.com/micahlmartin/Plant-Harmony/master/data/Plants.json


// Initialize things that needs to be initialized
- (id)init
{
    self = [super init];
    if (self) {
        
//        NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString* fileName = @"plantDataReal.json";
//        NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
//        NSLog(fileAtPath);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"plantDataReal" ofType:@"json"];
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSError *error =  nil;
        self.plantsDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        self.usersPlants = [NSMutableArray array];
    }
    return self;
}


// Takes the index in the array and returns the plan object. The name and other details
// can be gotten by calling [[self.plant getAPlant:index] objectForKey:@"key"];
-(NSMutableDictionary *) getAPlant: (NSInteger) plantIndex {
    return [self.plantsDataArray objectAtIndex:plantIndex] ;
}

-(NSString *) getAPlantName: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Name"];
}

-(NSString *) getAPlantFamily: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Family"];
}

-(NSString *) getAPlantHeight: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Height"];
}

-(NSString *) getAPlantSpacing: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Spacing per Square Foot"];
}

-(NSString *) getAPlantGrowingSeason: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Growing Season"];
}

-(NSString *) getAPlantWeeksFromSeedHarvest: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Weeks from Seed to Harvest"];
}

-(NSString *) getAPlantTimerCountDown: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Timer countdown in weeks"];
}

-(NSString *) getAPlantYearsStoreSeeds: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Years You can Store Seeds"];
}

-(NSString *) getAPlantWeeksToMaturity: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Weeks to Maturity"];
}

-(NSString *) getAPlantIndoorSeedStarting: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Indoor Seed Starting"];
}

-(NSString *) getAPlantEarliestOutdoorPlanting: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Earliest Outdoor Planting"];
}

-(NSString *) getAPlantLastPlanting: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Last Planting"];
}

-(NSString *) getAPlantDescription: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Description"];
}

-(NSString *) getAPlantLocation: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Location"];
}

-(NSString *) getAPlantTransplanting: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Transplanting"];
}

-(NSString *) getAPlantWatering: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Watering"];
}

-(NSString *) getAPlantMaintenance: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Maintenance"];
}

-(NSString *) getAPlantHarvesting: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Harvesting"];
}

-(NSString *) getAPlantPreparingAndUsing: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Preparing & Using"];
}

-(NSString *) getAPlantProblems: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Problems"];
}

-(NSString *) getAPlantPreparationUse: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"Preparation/Use"];
}

// When can call this function when a tableview item is clicked.
// Since we can easily get the index that was clicked, we can pass the index
// to this function and return the object that corressponds to the index
-(NSMutableDictionary *) getAPlantToPlace:(NSInteger) plantIndexFromTable {
    return [self.plantsDataArray objectAtIndex:plantIndexFromTable];
}

// This adds the item that was gotten to the user's plant array
// The collections views could always have the plants in the users array and this view gets
// updated when the user places a new plant to the array
// Since we could have the number of each plant that fits in a grid container as part of the json
// we can easily use that for placing

// The posOfPlant of plant can be gotten when after a plant is selected, a position to place the
// plant on the grid is clicked. This position is assigned to this function and something is done
// to position plant in that location and also store the position in the plants objects
// Have not figured it out yet
//- (void) placeAPlant: (NSInteger ) indexFromTable toPositionOnGrid:(NSInteger)posOfPlant {
//    [self.usersPlants addObject:[self getAPlantToPlace:indexFromTable]];
//}

// To add new tips, we could just push it to the array plantsDataArray and save it in the json file.
// Might be tricky since data is highly nested but it's doable.

// We could use the name of the plant to get to the index in the array.

// My guess is that we will need another json file to store the users garden data. When the user adds a plan, we could store in the same way this data is stored and also access it easily


// Temporary implementation. This just prints out all the tips from the array.
// Each tip on a new line seperated.
-(NSString *) getTips {
    return @"";
}



//The getter and setter for name and howManyPerSquare are already implemented by default.
// To set, do [theObject setName:@"name"]
//To get, do [theObject name]. Can be assigned to a string like so NSString * gottenName = [theObject name];

// I dont think we need this.
-(void) setImage: (NSString *) imageURL {
    
}

@end
