//
//  ViewControllerNotes.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-12.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerNotes.h"

@interface ViewControllerNotes () 

@end

@implementation ViewControllerNotes

#pragma mark - Notifications

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getFromNoteUserDefaults];
    
    self.clickedIndex = 0;
    if ([[GloablObjects notesInstance].notesArray count] <= 0) {
        self.notesField.text = @"";
    } else {
        self.notesField.text = [GloablObjects notesInstance].notesArray[0];
    }
    if ([[GloablObjects notesInstance].notesArray count] > 0) {
        self.notesField.text = [[GloablObjects notesInstance].notesArray objectAtIndex:0];
    }
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-texture-background.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    [self enableNoteField  ];
    self.justDel = false;
    
    // observe keyboard for inset
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultnote" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    self.notesField.text = string;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}

- (NSInteger)tableView:(UITableView *)tableView

 numberOfRowsInSection:(NSInteger)section
{
    return [[GloablObjects notesInstance].notesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: @"Cell" ];
    }
    
    NSInteger upperLimit = 24;
    if ([[[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row] length] < upperLimit) {
        upperLimit = [[[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row] length];
    }
    
    NSString * imgName = [NSString stringWithFormat:@"noteSmall.png"];
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = [[[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, upperLimit)] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self saveNote];
    self.notesField.text = [[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row];
    self.clickedIndex = indexPath.row;
    if (self.clickedIndex > [GloablObjects notesInstance].notesArray.count-1)
        self.clickedIndex = [GloablObjects notesInstance].notesArray.count-1;
    self.notesField.hidden = FALSE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    [[GloablObjects notesInstance].notesArray removeObjectAtIndex:indexPath.row ];
    [tableView reloadData];
    [self enableNoteField];
    self.justDel = true;
    if (self.clickedIndex == indexPath.row) {
        self.notesField.text = @"";
        self.notesField.hidden = true;
    }
    [self updateNoteUserDefaults];
    NSLog(@"Deleted row.");
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // keyboard frame is in window coordinates
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // convert own frame to window coordinates, frame is in superview's coordinates
    CGRect ownFrame = [self.view.window convertRect:self.view.frame fromView:self.view.superview];
    
    // calculate the area of own frame that is covered by keyboard
    CGRect coveredFrame = CGRectIntersection(ownFrame, keyboardFrame);
    
    // now this might be rotated, so convert it back
    coveredFrame = [self.view.window convertRect:coveredFrame toView:self.view.superview];
    
    // set inset to make up for covered height at bottom
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, coveredFrame.size.height, 0);
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.notesField.contentInset = insets;
                         self.notesField.scrollIndicatorInsets = insets;
                     } completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // set inset to make up for no longer covered array at bottom
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.notesField.contentInset = insets;
                         self.notesField.scrollIndicatorInsets = insets;
                     } completion:NULL];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self saveNote];
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.notesField isFirstResponder] && [touch view] != self.notesField) {
        [self.notesField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

-(void)saveNote {
    if([[GloablObjects notesInstance].notesArray count ]> 0 && !self.justDel) {
        [[GloablObjects notesInstance].notesArray replaceObjectAtIndex:self.clickedIndex withObject:self.notesField.text];
        [self updateNoteUserDefaults];
        [self.tableView reloadData];
    } else {
        self.justDel = !self.justDel;
    }
}

-(void) enableNoteField {
    if([[GloablObjects notesInstance].notesArray count ] == 0) {
        self.notesField.hidden = TRUE;
    } else {
        self.notesField.hidden = FALSE;
    }
}

-(IBAction) newNote: (id) sender {
    [self saveNote];
    NSString *note = @"";
    [[GloablObjects notesInstance].notesArray addObject:note];
    self.notesField.text =[NSString stringWithFormat:@"%@ ", note];
    [self.notesField showsHorizontalScrollIndicator];
    [self.tableView reloadData];
    [self enableNoteField];
    self.clickedIndex = [GloablObjects notesInstance].notesArray.count-1;
}

-(IBAction) goAllGardens: (id) sender {
    NSLog(@"clicked");
    [self.navigationController.presentingViewController.presentingViewController viewWillAppear:YES];
    [self.navigationController.presentingViewController.presentingViewController viewDidAppear:YES];
    if (self.navigationController.presentingViewController.presentingViewController) {
        [self.navigationController.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [self saveNote];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self._didScrollToTop)
    {
        // show scrolled to top on first layout. viewWillAppear does not work
        self.notesField.contentOffset = CGPointZero;
        self._didScrollToTop = YES;
    }
}


-(void) updateNoteUserDefaults {
    NSMutableArray *notesArray = [NSMutableArray arrayWithCapacity:[[GloablObjects notesInstance].notesArray count]];
    
    for (NSString * note in [GloablObjects notesInstance].notesArray) {
        [notesArray addObject:note];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:notesArray forKey:@"notesArray"];
    [userDefaults synchronize];
}

-(void) getFromNoteUserDefaults {
    //wipes all gardens, will be reloaded from user defaults
    [GloablObjects notesInstance].notesArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *notesArray = [userDefaults objectForKey:@"notesArray"];
    
    if (notesArray == nil) {
        NSLog(@"no notes found");
    } else {
        for (NSString * note in notesArray) {
            [[GloablObjects notesInstance].notesArray addObject:note];
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self saveNote];
}

@end
