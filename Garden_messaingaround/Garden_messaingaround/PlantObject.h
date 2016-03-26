//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlantObject : NSObject

// Array of dictionaries to be populated from a json file
// Feel free to edit the json file as you please
@property (strong, nonatomic) NSMutableArray *plantsDataArray;
// We might not need this anymore because it's all hnadled in this file.
// There is a call to this method in the welcome view
@property (strong, nonatomic) NSString * name;


@property (strong, nonatomic) NSMutableArray *usersPlants;


@property (strong, nonatomic) NSNumber * howManyPerSquare;


-(NSString *) getTips;

-(NSMutableDictionary *) getAPlant: (NSInteger) plantIndex ;
-(NSString *) getAPlantName: (NSInteger) plantIndex ;
-(NSString *) getAPlantFamily: (NSInteger) plantIndex;
-(NSString *) getAPlantHeight: (NSInteger) plantIndex;
-(NSString *) getAPlantSpacing: (NSInteger) plantIndex;
-(NSString *) getAPlantGrowingSeason: (NSInteger) plantIndex ;
-(NSString *) getAPlantWeeksFromSeedHarvest: (NSInteger) plantIndex ;
-(NSString *) getAPlantTimerCountDown: (NSInteger) plantIndex ;
-(NSString *) getAPlantYearsStoreSeeds: (NSInteger) plantIndex ;
-(NSString *) getAPlantWeeksToMaturity: (NSInteger) plantIndex ;
-(NSString *) getAPlantIndoorSeedStarting: (NSInteger) plantIndex ;
-(NSString *) getAPlantEarliestOutdoorPlanting: (NSInteger) plantIndex ;
-(NSString *) getAPlantLastPlanting: (NSInteger) plantIndex ;
-(NSString *) getAPlantDescription: (NSInteger) plantIndex ;
-(NSString *) getAPlantLocation: (NSInteger) plantIndex ;
-(NSString *) getAPlantTransplanting: (NSInteger) plantIndex ;
-(NSString *) getAPlantWatering: (NSInteger) plantIndex ;
-(NSString *) getAPlantMaintenance: (NSInteger) plantIndex ;
-(NSString *) getAPlantHarvesting: (NSInteger) plantIndex ;
-(NSString *) getAPlantPreparingAndUsing: (NSInteger) plantIndex ;
-(NSString *) getAPlantProblems: (NSInteger) plantIndex ;
-(NSString *) getAPlantPreparationUse: (NSInteger) plantIndex ;
-(NSString *) getAPlantFoes: (NSInteger) plantIndex ;

-(NSMutableDictionary *) getAPlantToPlace:(NSInteger) plantIndexFromTable;
- (void) placeAPlant: (NSInteger ) indexFromTable toPositionOnGrid:(NSInteger)posOfPlant;


-(NSString *) getHomePath:(NSString *) path ;
-(void)saveGardenToFile:(NSMutableArray *)data gardenName:(NSString *) gName ;
-(NSString *)getSavedGardenFromFile: (NSString *) gardenToGet;


-(void) saveDatatoDefaults: (NSMutableArray *) userGardendata theGardenName: (NSString *) gardenName ;
-(NSMutableArray *) getUserDataFromDefaults: (NSString *) gardenName ;

@end
