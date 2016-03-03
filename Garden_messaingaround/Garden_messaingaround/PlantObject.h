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


// This would hold the users plants and everything. This can be saved as a json
// file on the users device and it will be easy to populate the garden from the file.
// We might need to move this to another class/file when we are refactoring
@property (strong, nonatomic) NSMutableArray *usersPlants;


// How do we calculate how many of a plant can fit in one square.
// When we determine this, we could probably just add it as a field
// for each plant in the json file and call it from there.
// something like
//{
//    "name": "Onion",
//    "type": "Vegetable",
//    "companions": ["Tomato", "@Brassica", "Carrot"],
//    "foes": ["Legume", "Parsley"],
//    "squareFoot" : 4
//},
@property (strong, nonatomic) NSNumber * howManyPerSquare;


-(NSString *) getTips;

-(NSMutableDictionary *) getAPlant: (NSInteger) plantIndex ;
-(NSString *) getAPlantName: (NSInteger) plantIndex ;
-(NSString *) getAPlantDescription: (NSInteger) plantIndex;
-(NSString *) getAPlantCompanion: (NSInteger) plantIndex;
-(NSString *) getAPlantfoe: (NSInteger) plantIndex ;
-(NSString *) getAPlantType: (NSInteger) plantIndex;


-(NSMutableDictionary *) getAPlantToPlace:(NSInteger) plantIndexFromTable;
- (void) placeAPlant: (NSInteger ) indexFromTable toPositionOnGrid:(NSInteger)posOfPlant;

@end
