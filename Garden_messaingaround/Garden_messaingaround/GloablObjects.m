//
//  GloablObjects.m
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-02-28.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "GloablObjects.h"

static GloablObjects* _myGarden = nil;
@implementation GloablObjects
@synthesize myGarden;
-(id)init {
    if (self=[super init]) {
        self.myGarden = NO;
    }
    return self;
}
+(GloablObjects*)instance {
    if (!_myGarden) _myGarden = [[GloablObjects alloc] init];
    return _myGarden;
}
@end
