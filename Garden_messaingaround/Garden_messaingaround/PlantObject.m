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
        
//        NSMutableArray *topLevelArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *dict = topLevelArray[0];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"plantDataReal" ofType:@"json"];
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSError *error =  nil;
        self.plantsDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        self.usersPlants = [NSMutableArray array];
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

-(NSMutableDictionary *) getAPlantToPlace:(NSInteger) plantIndexFromTable {
    return [self.plantsDataArray objectAtIndex:plantIndexFromTable];
}

-(NSString *) getTips {
    return @"";
}

-(NSString *) getHomePath:(NSString *) path {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSArray *documents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    NSLog(@"Doc is: %@\n  Path is: %@", [documents description], basePath);
    
    
    return basePath;
}

-(void)saveGardenToFile:(NSMutableArray *)data gardenName:(NSString *) gName {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString * subPath = [NSString stringWithFormat:@"/UserGardens/%@.json", gName];
    NSString *userDataPath = [documentsDirectory stringByAppendingPathComponent:subPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:userDataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    [data writeToFile:userDataPath atomically:YES];
    NSLog(@"Path is: %@\n", userDataPath);
    
}

-(NSString *)getSavedGardenFromFile: (NSString *) gardenToGet {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString * subPath = [NSString stringWithFormat:@"/UserGardens/%@.json", gardenToGet];
    NSString *userDataPath = [documentsDirectory stringByAppendingPathComponent:subPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:userDataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    NSLog(@"Get Path is: %@\n", userDataPath);
    
    NSString *content = [NSString stringWithContentsOfFile:userDataPath encoding:NSUTF8StringEncoding error:NULL];
    
    return content;
}




-(void) saveDatatoDefaults: (NSMutableArray *) userGardendata theGardenName: (NSString *) gardenName {    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    if([[NSUserDefaults standardUserDefaults] objectForKey:gardenName] != nil) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [defaults setObject:[userGardendata mutableCopy] forKey:gardenName];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
}

- (id) objectFromDataWithKey:(NSString*)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(NSMutableArray *) getUserDataFromDefaults: (NSString *) gardenName {    return [self objectFromDataWithKey:gardenName] ;
    
}

-(void) setImage: (NSString *) imageURL {
    
}

@end
