//
//  ViewControllerPlantViews.h
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-12.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlantObject.h"

@interface ViewControllerPlantViews : UIViewController

@property IBOutlet UILabel * name;
@property IBOutlet UILabel * family;
@property IBOutlet UILabel * height;
@property IBOutlet UILabel * numPerSqFt;
@property IBOutlet UILabel * season;
@property IBOutlet UILabel * seedToHarvest;
@property IBOutlet UILabel * wksToMature;
@property IBOutlet UITextView *comment;
@property IBOutlet UIImageView * previewImage;
@property IBOutlet UITableView *table;

@property int clickedIndex;


-(IBAction) goAllGardens: (id) sender;
-(IBAction) updateComment: (id) sender;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)keyboardWillShow;
-(void)keyboardWillHide;
-(void)textFieldDidBeginEditing:(UITextField *)sender;
-(void)setViewMovedUp:(BOOL)movedUp;

-(void) updateCommentUserDefaults;
-(void) getFromCommentUserDefaults;

@end
