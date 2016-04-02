//
//  ViewControllerNotes.h
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-12.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GloablObjects.h"


@interface ViewControllerNotes : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *notesField;
@property IBOutlet UITableView *tableView;
@property NSInteger clickedIndex;
@property BOOL justDel;
@property BOOL _didScrollToTop;

@end
