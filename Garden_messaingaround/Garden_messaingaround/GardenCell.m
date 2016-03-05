//
//  GardenCell.m
//  Garden_messaingaround
//
//  Created by Qi Guo on 2016-03-03.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "GardenCell.h"

@implementation GardenCell
- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"help");
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont boldSystemFontOfSize:35.0];
        self.label.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:self.label];
    }
    return self;
}
- (void)setText:(NSString *)text {
    self.label.text = text;
}
@end
