
//
//  ViewControllerDisplayGarden.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerDisplayGarden.h"
#import "GloablObjects.h"
#import "PlantObject.h"
#import <Social/Social.h>

@interface ViewControllerDisplayGarden () {
    IBOutlet UICollectionView *collectionView;
    IBOutlet UITableView *tableView;
    UIImageView *backgroundimgview;
    dispatch_once_t onceToken;
    int alert;
    bool delmode ;

//    IBOutlet UITableView * tableView;
    IBOutlet UIImageView * shot;
    IBOutlet UIButton * takePhoto;
}

@property GardenObject * garden;
@property NSInteger brushIndex;
@property NSInteger clickedIndex;

@end

@implementation ViewControllerDisplayGarden


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    alert = 0;
    //sets title bar
    [self setTitle:[GloablObjects instance].myGarden.name];
    delmode = false;
    UICollectionViewFlowLayout *layout = (id) collectionView.collectionViewLayout;
    
    float screenWidth = layout.collectionViewContentSize.width;
    float widthOfCell = (screenWidth)/([[GloablObjects instance].myGarden getWidth])-1;

    
    layout.itemSize = CGSizeMake(widthOfCell, widthOfCell);
    
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 1.0f;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView.collectionViewLayout = layout;
//    
//    [self createScrollView:collectionView.frame.size.width
//                 andHeight:collectionView.frame.size.height
//                   startAt:collectionView.frame.origin.x
//                     endAt:collectionView.frame.origin.y];
//    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.plant = [[PlantObject alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    [self.plant saveGardenToFile:[self.plant plantsDataArray] gardenName:@"testArr" ];
    [self.plant getSavedGardenFromFile:@"testArr"];
    NSLog(@"Get Link is: %@\n ", [self.plant getSavedGardenFromFile:@"testArr"]);

    
    self.tabBarItem.image = [[UIImage imageNamed:@"noteSmall.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    PlantObject *myPlant = [PlantObject new];
    myPlant.name = [self.plant getAPlantName:0];
    [GloablObjects paintBrushInstance].paintBrush = myPlant;
}



- (void)createScrollView: (CGFloat) width andHeight:(CGFloat)height startAt: (CGFloat) leftPos endAt: (CGFloat) endPpos {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftPos, endPpos, width, height)];
    
    scrollView.contentSize = CGSizeMake(width, height);
    scrollView.backgroundColor = [UIColor clearColor];

    
    [self.view addSubview:scrollView];
    [scrollView addSubview:collectionView];
}

-(IBAction) modifyGarden: (id) sender {
    [self performSegueWithIdentifier:@"showModify" sender:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [GloablObjects instance].myGarden.gardenArr2d.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bounds.size.width*.65, cell.bounds.size.width, 40)];
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.20, cell.bounds.size.height*.1, cell.bounds.size.width*.6, cell.bounds.size.height*.6)];
    title.textColor = [UIColor blackColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0;
    //title.minimumFontSize = 0;
    
    UILabel *numPerSq = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bounds.size.width*.85, cell.bounds.size.width, 40)];
    numPerSq.textColor = [UIColor blackColor];
    [numPerSq setTextAlignment:NSTextAlignmentCenter];
    numPerSq.adjustsFontSizeToFitWidth = YES;
    numPerSq.minimumScaleFactor = 0;
    //numPerSq.minimumFontSize = 0;
    numPerSq.text = @"";
    
    GardenObject* g = [GloablObjects instance].myGarden.gardenArr2d[indexPath.row];
    title.text = g.name;
    
    //semi transparent background
    backgroundimgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*0.05, cell.bounds.size.height*0.05, cell.bounds.size.width*.9, cell.bounds.size.height*.9)];
    backgroundimgview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", g.name, @"png"] lowercaseString] ;
    
    
    imgview.image = [ UIImage imageNamed: imgName];
    [cell.contentView addSubview:backgroundimgview];
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:imgview];
    [cell.contentView addSubview:numPerSq];
    
    return cell;
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


-(bool)checkfoes:(int) index {
    NSString * neighborName = @"";
    NSString *foes = [self.plant getAPlantFoes:self.brushIndex];
    PlantObject *plant = [[GloablObjects instance].myGarden.gardenArr2d objectAtIndex:0];
    NSMutableString * message = @" doesn't grow well with: ";
    BOOL found = false;
    
    message = [NSMutableString stringWithFormat:@"%@%@", [self.plant getAPlantName:self.brushIndex], message];
    
    if (index-1 >= 0 && index%[GloablObjects instance].myGarden.width != 0) {
        plant = [[GloablObjects instance].myGarden.gardenArr2d objectAtIndex:(index-1)];
        neighborName = plant.name;
        
        if (!([foes rangeOfString:neighborName].location == NSNotFound)) {
            found = true;
            message = [NSMutableString stringWithFormat:@"%@\n%@", message, neighborName];
        }
    }
    
    if (index+1 < [[GloablObjects instance].myGarden.gardenArr2d count] && index%[GloablObjects instance].myGarden.width != [GloablObjects instance].myGarden.width-1) {
        plant = [[GloablObjects instance].myGarden.gardenArr2d objectAtIndex:(index+1)];
        neighborName = plant.name;
        
        if (!([foes rangeOfString:neighborName].location == NSNotFound)) {
            found = true;
            message = [NSMutableString stringWithFormat:@"%@\n%@", message, neighborName];
        }
    }
    
    if (index+[GloablObjects instance].myGarden.width < ([[GloablObjects instance].myGarden.gardenArr2d count])) {
        
        plant = [[GloablObjects instance].myGarden.gardenArr2d objectAtIndex:(index+[GloablObjects instance].myGarden.width)];
        neighborName = plant.name;
        
        if (!([foes rangeOfString:neighborName].location == NSNotFound)) {
            found = true;
            message = [NSMutableString stringWithFormat:@"%@\n%@", message, neighborName];
        }
    }
    
    if (index-[GloablObjects instance].myGarden.width >= 0) {
        plant = [[GloablObjects instance].myGarden.gardenArr2d objectAtIndex:(index-[GloablObjects instance].myGarden.width)];
        neighborName = plant.name;
        
        if (!([foes rangeOfString:neighborName].location == NSNotFound)) {
            found = true;
            message = [NSMutableString stringWithFormat:@"%@\n%@", message, neighborName];
        }
    }
    if(!delmode){
        alert = 1;
        if (found) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMBATIVE WARNING!"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Undo"
                                                  otherButtonTitles:@"Continue",nil];
            [alert show];
            
        }
    }
    
    return found;
}


//http://stackoverflow.com/questions/18857167/uicollectionview-cell-selection

//called when items are selected from the collection view
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickedIndex = indexPath.row;
    [self checkfoes:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bounds.size.width*.65, cell.bounds.size.width, 40)];
    title.textColor = [UIColor blackColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0;
    //title.minimumFontSize = 0;
    title.text = [GloablObjects paintBrushInstance].paintBrush.name;
    
    UILabel *numPerSq = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bounds.size.width*.85, cell.bounds.size.width, 40)];
    numPerSq.textColor = [UIColor blackColor];
    [numPerSq setTextAlignment:NSTextAlignmentCenter];
    numPerSq.adjustsFontSizeToFitWidth = YES;
    numPerSq.minimumScaleFactor = 0;
    //numPerSq.minimumFontSize = 0;
    numPerSq.text = @"";
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.20, cell.bounds.size.height*.1, cell.bounds.size.width*.6, cell.bounds.size.height*.6)];
    
    //semi transparent background
    backgroundimgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*0.05, cell.bounds.size.height*0.05, cell.bounds.size.width*.9, cell.bounds.size.height*.9)];
    backgroundimgview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [GloablObjects paintBrushInstance].paintBrush.name, @"png"] lowercaseString] ;
    [[GloablObjects instance].myGarden.gardenArr2d replaceObjectAtIndex:indexPath.row withObject:[GloablObjects paintBrushInstance].paintBrush];
    
    imgview.image = [ UIImage imageNamed: imgName];
    [cell.contentView addSubview:backgroundimgview];
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:numPerSq];
    [cell.contentView addSubview:imgview];
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    
    [self updateUserDefaults];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
//    return( [[self.plant plantsDataArray] indexOfObject:[[self.plant plantsDataArray] lastObject]] + 1 );
    return [[self.plant plantsDataArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
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
    
  //  tableView.backgroundColor = [UIColor redColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set background back to the original one when tableview is selected
    collectionView.backgroundColor = [UIColor clearColor];
    delmode = NO;
    PlantObject* brush = [PlantObject alloc];
    brush.name = [self.plant getAPlantName:indexPath.row];
    self.brushIndex = indexPath.row;
    [GloablObjects paintBrushInstance].paintBrush = brush;
    
}

// Size of the cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(IBAction) removeTool: (id) sender {
    // red background when remove button clicked
    collectionView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
    delmode = YES;
    alert = 0;
    dispatch_once (&onceToken, ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                        message:@"You are about to remove plants from your garden! Are you sure you to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue",nil];
        [alert show];
    });
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.brushIndex inSection:0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlantObject *myPlant = [PlantObject new];
    myPlant.name = @"";
    [GloablObjects paintBrushInstance].paintBrush = myPlant;
    [collectionView reloadData];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alert == 0) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.brushIndex inSection:0];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            PlantObject *myPlant = [PlantObject new];
            myPlant.name = @"";
            [GloablObjects paintBrushInstance].paintBrush = myPlant;
            [collectionView reloadData];
        } else {
            // Set background back to the original one when cancel button is selected
            collectionView.backgroundColor = [UIColor clearColor];
            //[collectionView reloadData];
        }
    } else if (alert == 1) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            //hit okay
        } else {
            PlantObject *myPlant = [PlantObject new];
            myPlant.name = @"";
            [[GloablObjects instance].myGarden.gardenArr2d replaceObjectAtIndex:self.clickedIndex withObject:myPlant];
            [collectionView reloadData];
        }
    }
}

-(UIImage *)capture{
    
    [collectionView reloadData];
    
    CGRect frame = collectionView.frame;
    frame.size.height = collectionView.contentSize.height;
    collectionView.frame = frame;
    
    UIGraphicsBeginImageContextWithOptions(collectionView.bounds.size, collectionView.opaque, 4.0);
//    UIGraphicsBeginImageContext(collectionView.bounds.size);
    [collectionView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // Save image.
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    
    return image;
}

-(IBAction) takePhoto: (id) sender {
    shot.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    shot.image = [self capture];
    shot.hidden = NO;
    shot.alpha = 1.0f;
    [shot setNeedsDisplay];
    NSString *message = @"Garden Saved to Photos";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        shot.alpha = 0.0f;
    } completion:^(BOOL finished) {
        shot.image = nil;
        shot.hidden = YES;
    }];
    [self.view addSubview:collectionView] ;
}



-(IBAction) facebookShareGarden: (id) sender {
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composeController setInitialText:@"Check Out My Garden"];
    [composeController addImage:[self capture]];
    if (composeController != nil) {
        [self presentViewController:composeController
                           animated:YES completion:nil];
    }
    
}

-(IBAction) twitterShareGarden: (id) sender {
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [composeController setInitialText:@"Check Out My Garden"];
    [composeController addImage:[self capture]];
    if (composeController != nil) {
        [self presentViewController:composeController
                           animated:YES completion:nil];
    }
    
}

-(void) synchData {
    NSLog(@"Kind of GlobalObjects is kind of : %@\n ",[[GloablObjects gardenArrayInstance].gardenArray   class]);
    
//    [self.plant saveGardenToFile::[GloablObjects gardenArrayInstance].gardenArray[ theGardenName:@"UUUUU"];
//    [self.plant saveDatatoDefaults:[GloablObjects gardenArrayInstance].gardenArray theGardenName:@"newSS"];
     [self.plant saveGardenToFile:[self.plant plantsDataArray] gardenName:@"toJson"];
    [self.plant getSavedGardenFromFile:@"newSS"];
    NSLog(@"From Json is: %@\n ", [self.plant getSavedGardenFromFile:@"toJson"]);
//    NSLog(@"File in TESTARR is: %@\n ", [self.plant getSavedGardenFromFile:@"testArr"]);
//    NSLog(@"File in UUUUU is: %@\n ", [self.plant getUserDataFromDefaults:@"UUUUU"]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSArray *documents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    //
    //    http://stackoverflow.com/questions/4934389/storing-json-data-on-the-iphone-save-the-json-string-as-it-is-vs-make-an-object
    NSURL *URL;
    NSString *completeFilePath;
    for (NSString *file in documents) {
        completeFilePath = [NSString stringWithFormat:@"%@/%@", basePath, file];
        URL = [NSURL fileURLWithPath:completeFilePath];
        NSLog(@"Folder contains is %@ ", file);
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self isMovingFromParentViewController])
    {
        NSLog(@"View controller was popped");
    }
    else
    {
        NSLog(@"New view controller was pushed");
        [self synchData];
    }
}


-(void) updateUserDefaults {
    NSMutableArray *gardens = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenNames = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenWidth = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenHeight = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    
    for (GardenObject * gard in [GloablObjects gardenArrayInstance].gardenArray) {
        [gardenNames addObject:gard.name];
        NSNumber *w = [NSNumber numberWithInteger:gard.width];
        NSNumber *h = [NSNumber numberWithInteger:gard.height];
        [gardenHeight addObject:w];
        [gardenWidth addObject:h];
        NSLog(@"%d", [gardenHeight[0] integerValue]);
        NSMutableArray *garden = [NSMutableArray arrayWithCapacity:[gard.gardenArr2d count]];
        for (PlantObject * plant in gard.gardenArr2d) {
            if ([ plant.name isEqualToString:@"" ]) {
                [garden addObject:@""];
            } else {
                [garden addObject:plant.name];
            }
        }
        [gardens addObject:garden];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:gardens forKey:@"gardens"];
    [userDefaults setObject:gardenNames forKey:@"gardenNames"];
    [userDefaults setObject:gardenWidth forKey:@"gardenWidth"];
    [userDefaults setObject:gardenHeight forKey:@"gardenHeight"];
    [userDefaults synchronize];
}

-(void) getFromUserDefaults {
    //wipes all gardens, will be reloaded from user defaults
    [GloablObjects gardenArrayInstance].gardenArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gardens = [userDefaults objectForKey:@"gardens"];
    NSMutableArray *gardenNames = [userDefaults objectForKey:@"gardenNames"];
    NSMutableArray *gardenWidth = [userDefaults objectForKey:@"gardenWidth"];
    NSMutableArray *gardenHeight = [userDefaults objectForKey:@"gardenHeight"];
    
    if (gardens == nil || gardenNames == nil) {
        NSLog(@"gardens not found. creating new instance.");
    } else {
        NSLog(@"gardens found. loading from file.");
        int i = 0;
        for (NSMutableArray * gard in gardens) {
            NSLog(@"help");
            GardenObject * newGarden = [[GardenObject alloc] init];
            [newGarden allocateTable:[gardenWidth[i] integerValue] withWidth:[gardenHeight[i] integerValue]];
            [newGarden setName:gardenNames[i]];
            
            int j = 0;
            for (NSString * plant in gard) {
                PlantObject * newPlant = [[PlantObject alloc] init];
                if ([plant isEqualToString:@"" ]) {
                    newPlant.name = @"";
                } else {
                    newPlant.name = plant;
                }
                [newGarden.gardenArr2d replaceObjectAtIndex:j withObject:newPlant];
                j+=1;
            }
            [[GloablObjects gardenArrayInstance].gardenArray addObject:newGarden];
            i+=1;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"data reload");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self viewDidLoad];
        [collectionView reloadData];
        [self.view setNeedsDisplay];
    });
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"data reload");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self viewDidLoad];
        [collectionView reloadData];
        [self.view setNeedsDisplay];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self synchData];

}



@end
