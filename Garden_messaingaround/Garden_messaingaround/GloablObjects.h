//
//  GloablObjects.h
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-02-28.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GardenObject.h"

@interface GloablObjects : NSObject
@property (nonatomic, readwrite) GardenObject* myGarden;
@property (nonatomic, readwrite) NSMutableArray* gardenArray;
@property (nonatomic, readwrite) PlantObject* paintBrush;
@property (nonatomic, readwrite) NSMutableArray* notesArray;
@property (nonatomic, readwrite) NSMutableArray* alarmArray;


-(id)init;
+(GloablObjects*)instance;
+(GloablObjects*)gardenArrayInstance;
+(GloablObjects*)paintBrushInstance;
+(GloablObjects*)notesInstance;
+(GloablObjects*)alarmInstance;
@end
