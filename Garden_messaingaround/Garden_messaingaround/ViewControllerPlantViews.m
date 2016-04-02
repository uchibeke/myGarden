//
//  ViewControllerPlantViews.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-12.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerPlantViews.h"
#import "GloablObjects.h"
#define kOFFSET_FOR_KEYBOARD 345.0

@interface ViewControllerPlantViews () {
    IBOutlet UILabel * name;
    IBOutlet UILabel * family;
    IBOutlet UILabel * height;
    IBOutlet UILabel * numPerSqFt;
    IBOutlet UILabel * season;
    IBOutlet UILabel * seedToHarvest;
    IBOutlet UILabel * wksToMature;
    IBOutlet UILabel * description;
    
    IBOutlet UITextView *comment;

    IBOutlet UIImageView * previewImage;
    
    IBOutlet UITableView *table;
    
    int clickedIndex;
}
@end

@implementation ViewControllerPlantViews

-(IBAction) updateComment: (id) sender {
    NSMutableArray* temp = [[GloablObjects commentsInstance].commentsArray mutableCopy];
    temp[clickedIndex] = comment.text;
    [GloablObjects commentsInstance].commentsArray = temp;
    [self updateCommentUserDefaults];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[GloablObjects plantDataInstance].plantData plantsDataArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: @"Cell" ];
    }
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    CGSize itemSize = CGSizeMake(32, 32);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row]] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateComment:self];
    
    name.text = [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row];
    
    family.text = [[GloablObjects plantDataInstance].plantData getAPlantFamily:indexPath.row];
    
    height.text = [[GloablObjects plantDataInstance].plantData getAPlantHeight:indexPath.row];
    
    season.text = [[GloablObjects plantDataInstance].plantData getAPlantGrowingSeason:indexPath.row];
    
    wksToMature.text = [[GloablObjects plantDataInstance].plantData getAPlantWeeksToMaturity:indexPath.row];
    
    seedToHarvest.text = [NSString stringWithFormat:@"%@ %@", [[GloablObjects plantDataInstance].plantData getAPlantWeeksFromSeedHarvest:indexPath.row], @"Weeks"];
    
    description.text = [[GloablObjects plantDataInstance].plantData getAPlantDescription:indexPath.row];
    
    numPerSqFt.text = [[GloablObjects plantDataInstance].plantData getAPlantSpacing:indexPath.row];
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    
    comment.text = [GloablObjects commentsInstance].commentsArray[indexPath.row];
    
    previewImage.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    previewImage.image = [UIImage imageNamed:imgName];
    
    
    // Save the comment
    clickedIndex = indexPath.row;
    
    
}


// Hide the keyboard when losing focus on the UITextField for comments
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self updateComment:self];
    UITouch *touch = [[event allTouches] anyObject];
    if ([comment isFirstResponder] && [touch view] != comment) {
        [comment resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

// Size of the cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getFromCommentUserDefaults];
    
    name.text = [[GloablObjects plantDataInstance].plantData getAPlantName:5];
    
    family.text = [[GloablObjects plantDataInstance].plantData getAPlantFamily:5];
    
    height.text = [[GloablObjects plantDataInstance].plantData getAPlantHeight:5];
    
    season.text = [[GloablObjects plantDataInstance].plantData getAPlantGrowingSeason:5];
    
    wksToMature.text = [[GloablObjects plantDataInstance].plantData getAPlantWeeksToMaturity:5];
    
    seedToHarvest.text = [NSString stringWithFormat:@"%@ %@", [[GloablObjects plantDataInstance].plantData getAPlantWeeksFromSeedHarvest:5], @"Weeks"];
    
    description.text = [[GloablObjects plantDataInstance].plantData getAPlantDescription:5];
    
    numPerSqFt.text = [[GloablObjects plantDataInstance].plantData getAPlantSpacing:5];
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [[GloablObjects plantDataInstance].plantData getAPlantName:5], @"png"] lowercaseString] ;
    
    previewImage.image = [UIImage imageNamed:imgName];
    previewImage.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    comment.text = [GloablObjects commentsInstance].commentsArray[5];
    
    clickedIndex = 5;
    //sets title bar
    [self setTitle:@"Plants"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3.png"]];
    //self.view.contentMode = UIViewContentModeScaleAspectFit;

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self updateComment:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:comment])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void) updateCommentUserDefaults {
    NSMutableArray *commentsArray = [NSMutableArray arrayWithCapacity:[[GloablObjects commentsInstance].commentsArray count]];
    
    for (NSString * comment in [GloablObjects commentsInstance].commentsArray) {
        [commentsArray addObject:comment];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:commentsArray forKey:@"commentsArray"];
    [userDefaults synchronize];
}

-(void) getFromCommentUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *commentArray = [userDefaults objectForKey:@"commentsArray"];
    
    if (commentArray == nil) {
        NSLog(@"no notes found");
    } else {
        [GloablObjects commentsInstance].commentsArray = [userDefaults objectForKey:@"commentsArray"];
    }
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self updateComment:self];
}

@end
