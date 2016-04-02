//
//  PlantData.m
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-04-02.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "PlantData.h"

@implementation PlantData


- (id)init
{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"plantDataReal" ofType:@"json"];
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSError *error =  nil;
        self.plantsDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    }
    return self;
}


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

-(NSString *) getAPlantFoes: (NSInteger) plantIndex {
    return [[self.plantsDataArray objectAtIndex:plantIndex] objectForKey:@"foes"];
    
}

@end
