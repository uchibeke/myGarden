//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlantObject.h"

@interface GardenObject : NSObject

@property NSString* name;
@property NSInteger width;
@property NSInteger height;

@property NSMutableArray * gardenArr2d ;

- (void) allocateTable:(NSInteger)h withWidth:(NSInteger) w;

@end
