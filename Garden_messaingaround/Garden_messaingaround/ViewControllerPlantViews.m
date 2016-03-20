//
//  ViewControllerPlantViews.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-12.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerPlantViews.h"
#define kOFFSET_FOR_KEYBOARD 250.0

@interface ViewControllerPlantViews () {
    IBOutlet UILabel * name;
    IBOutlet UILabel * family;
    IBOutlet UILabel * height;
    IBOutlet UILabel * numPerSqFt;
    IBOutlet UILabel * season;
    IBOutlet UILabel * seedToHarvest;
    IBOutlet UILabel * wksToMature;
    IBOutlet UILabel * description;
    
    IBOutlet UIButton *commentBtn;
    IBOutlet UITextView *comment;

    IBOutlet UIImageView * previewImage;
    
    IBOutlet UITableView *table;
    
    int clickedIndex;
}
@end

@implementation ViewControllerPlantViews

-(IBAction) updateComment: (id) sender {
    
    NSMutableDictionary *dic = [[self.plant.plantsDataArray objectAtIndex:clickedIndex] mutableCopy];
    [dic setObject:comment.text forKey:@"Transplanting"];
    
    //trasplant is temp comments section
    NSMutableArray * md = [self.plant.plantsDataArray mutableCopy];
    [md replaceObjectAtIndex:clickedIndex withObject:dic];
    self.plant.plantsDataArray = [md mutableCopy];
    
    
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(filePath);
    NSString* fileName = @"plantDataReal.json";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[[md description] dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
    
//    
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.plant.plantsDataArray
//                                                                               options:kNilOptions
//                                                                                 error:nil];
//    [jsonData writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",
//                                                 NSTemporaryDirectory(), @"plantDataReal.json"]] atomically:YES];
    [table reloadData];
    
//    [self.plant.plantsDataArray addObject:@"{\"Test\": \"Test\"}"];
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.plant.plantsDataArray
//                                                       options:kNilOptions
//                                                         error:nil];
//    
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"plantDataReal" ofType:@"json"];
//      NSFileManager *fileManager = [NSFileManager defaultManager];
//      [fileManager createFileAtPath:filePath contents:jsonData attributes:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.plant plantsDataArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: @"Cell" ];
    }
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [self.plant getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    CGSize itemSize = CGSizeMake(32, 32);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"", [self.plant getAPlantName:indexPath.row]] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    name.text = [self.plant getAPlantName:indexPath.row];
    
    family.text = [self.plant getAPlantFamily:indexPath.row];
    
    height.text = [self.plant getAPlantHeight:indexPath.row];
    
    season.text = [self.plant getAPlantGrowingSeason:indexPath.row];
    
    wksToMature.text = [self.plant getAPlantWeeksToMaturity:indexPath.row];
    
    seedToHarvest.text = [NSString stringWithFormat:@"%@ %@", [self.plant getAPlantWeeksFromSeedHarvest:indexPath.row], @"Weeks"];
    
    description.text = [self.plant getAPlantDescription:indexPath.row];
    
    numPerSqFt.text = [self.plant getAPlantSpacing:indexPath.row];
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [self.plant getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    
    comment.text = [self.plant getAPlantTransplanting:indexPath.row];
    
    previewImage.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    previewImage.image = [UIImage imageNamed:imgName];
    

    clickedIndex = indexPath.row;
    
    
}


// Hide the keyboard when losing focus on the UITextField for comments
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
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
    
    self.plant = [[PlantObject alloc]init];
    name.text = [self.plant getAPlantName:0];
    
    family.text = [self.plant getAPlantFamily:0];
    
    height.text = [self.plant getAPlantHeight:0];
    
    season.text = [self.plant getAPlantGrowingSeason:0];
    
    wksToMature.text = [self.plant getAPlantWeeksToMaturity:0];
    
    seedToHarvest.text = [NSString stringWithFormat:@"%@ %@", [self.plant getAPlantWeeksFromSeedHarvest:0], @"Weeks"];
    
    description.text = [self.plant getAPlantDescription:0];
    
    numPerSqFt.text = [self.plant getAPlantSpacing:0];
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [self.plant getAPlantName:0], @"png"] lowercaseString] ;
    
    previewImage.image = [UIImage imageNamed:imgName];
    previewImage.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    comment.text = [self.plant getAPlantTransplanting:0];
    
    clickedIndex = 0;
    //sets title bar
    [self setTitle:@"Plants"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3.png"]];
    //self.view.contentMode = UIViewContentModeScaleAspectFit;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

@end
