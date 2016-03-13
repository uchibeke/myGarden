//
//  GloablObjects.m
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-02-28.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "GloablObjects.h"

static GloablObjects* _myGarden = nil;
static GloablObjects* _gardenArray = nil;
static GloablObjects* _paintBrush = nil;
static GloablObjects* _notesArray = nil;

@implementation GloablObjects

@synthesize myGarden;
@synthesize gardenArray;
@synthesize paintBrush;
@synthesize notesArray;

-(id)init {
    if (self=[super init]) {
        self.myGarden = nil;
        self.gardenArray = nil;
        self.paintBrush = nil;
        self.notesArray = nil;
    }
    return self;
}

+(GloablObjects*)instance {
    if (!_myGarden) _myGarden = [[GloablObjects alloc] init];
    return _myGarden;
}

+(GloablObjects*)gardenArrayInstance {
    if (!_gardenArray) _gardenArray = [[GloablObjects alloc] init];
    return _gardenArray;
}

+(GloablObjects*)paintBrushInstance {
    if (!_paintBrush) _paintBrush = [[GloablObjects alloc] init];
    return _paintBrush;
}

+(GloablObjects*)notesInstance {
    if (!_notesArray) _notesArray = [[GloablObjects alloc] init];
    return _notesArray;
}
@end
