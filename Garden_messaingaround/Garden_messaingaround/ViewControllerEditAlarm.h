//
//  ViewControllerEditAlarm.h
//  
//
//  Created by Qi Guo on 2016-03-21.
//
//

#import <UIKit/UIKit.h>

@interface ViewControllerEditAlarm : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIDatePicker *timeToSetOff;
@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, assign) NSInteger indexOfAlarmToEdit;
@property(atomic,strong) NSString *label;
@property(nonatomic,assign) BOOL editMode;
@property(nonatomic,assign) int notificationID;
@end
