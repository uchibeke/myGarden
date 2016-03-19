//
//  ViewControllerReminders.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-19.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerReminders.h"

@interface ViewControllerReminders () {
    IBOutlet UIPickerView *picker;
}

@end

@implementation ViewControllerReminders

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // assumes global UIPickerView declared. Move the frame to wherever you want it
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    picker.dataSource = self;
    picker.delegate = self;
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, picker.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hour";
    [picker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (picker.frame.size.width / 3), picker.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"min";
    [picker addSubview:minsLabel];
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + ((picker.frame.size.width / 3) * 2), picker.frame.size.height / 2 - 15, 75, 30)];
    secsLabel.text = @"sec";
    [picker addSubview:secsLabel];
    
    [self.view addSubview:picker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 24;
    
    return 60;
}

@end
