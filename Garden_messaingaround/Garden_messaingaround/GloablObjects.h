//
//  GloablObjects.h
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-02-28.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GardenObject.h"
#import "PlantData.h"

@interface GloablObjects : NSObject
@property (nonatomic, readwrite) GardenObject* myGarden;
@property (nonatomic, readwrite) NSMutableArray* gardenArray;

@property (nonatomic, readwrite) PlantObject* paintBrush;

@property (nonatomic, readwrite) NSMutableArray* notesArray;
@property (nonatomic, readwrite) NSMutableArray* alarmArray;
@property (nonatomic, readwrite) NSMutableArray* commentsArray;

@property (nonatomic, readwrite) PlantData* plantData;

-(id)init;
+(GloablObjects*)instance;
+(GloablObjects*)gardenArrayInstance;
+(GloablObjects*)paintBrushInstance;
+(GloablObjects*)notesInstance;
+(GloablObjects*)alarmInstance;
+(GloablObjects*)commentsInstance;
+(GloablObjects*)plantDataInstance;
@end
