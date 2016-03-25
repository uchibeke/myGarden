//
//  gardenAlarm.h
//  Garden_messaingaround
//
//  Created by Wyatt Grant on 2016-03-25.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gardenAlarm : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * message;
@property (strong, nonatomic) NSDate * time;

@end
