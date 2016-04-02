//
//  PlantData.h
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-04-02.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlantData : NSObject

@property (strong, nonatomic) NSMutableArray *plantsDataArray;

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

@end
