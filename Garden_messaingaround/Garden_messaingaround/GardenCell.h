//
//  GardenCell.h
//  Garden_messaingaround
//
//  Created by Qi Guo on 2016-03-03.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GardenCell : UICollectionViewCell
@property (retain, nonatomic) UILabel* label;

- (void)setText:(NSString*)text;
@end
