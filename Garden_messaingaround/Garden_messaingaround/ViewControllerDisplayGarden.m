
//
//  ViewControllerDisplayGarden.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerDisplayGarden.h"
#import "GloablObjects.h"
#import <Social/Social.h>

@interface ViewControllerDisplayGarden () {
    dispatch_once_t onceToken;
}

@end

@implementation ViewControllerDisplayGarden


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sets title, backgorund image and tab image
    [self setTitle:[GloablObjects instance].myGarden.name];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    self.tabBarItem.image = [[UIImage imageNamed:@"noteSmall.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //initalize varbles for which alert is shown, and if we are in delete mode
    self.delmode = false;
    self.alert = 0;
    self.brushIsInit = NO;
    
    //layout for the collection view changed so the garden is the correct width and height
    UICollectionViewFlowLayout *layout = (id) self.collectionView.collectionViewLayout;
    float screenWidth = layout.collectionViewContentSize.width;
    float widthOfCell = (screenWidth)/([GloablObjects instance].myGarden.width)-1;
    layout.itemSize = CGSizeMake(widthOfCell, widthOfCell);
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 1.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = layout;
    
    //initalize the paint brush to an 'empty plant'
    PlantObject *myPlant = [PlantObject new];
    myPlant.name = [[GloablObjects plantDataInstance].plantData getAPlantName:0];
    [GloablObjects paintBrushInstance].paintBrush = myPlant;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [GloablObjects instance].myGarden.gardenArr2d.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //gets plant in current cell
    PlantObject* p = [GloablObjects instance].myGarden.gardenArr2d[indexPath.row];
    
    //gets a reference to the cell
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //sets title and their properties for each square
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bounds.size.width*.65, cell.bounds.size.width, 40)];
    title.textColor = [UIColor whiteColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0;
    title.text = @"";
    if (([GloablObjects instance].myGarden.width) < 7) {
        title.text = p.name;
    }
    
    //sets number to plant per sq/ft and the texts properties for each square
    UILabel *plantsPerRow = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.05, cell.bounds.size.width*.01, cell.bounds.size.width*.9, 40)];
    plantsPerRow.textColor = [UIColor whiteColor];
    [plantsPerRow setTextAlignment:NSTextAlignmentCenter];
    [plantsPerRow setFont: [plantsPerRow.font fontWithSize: 13]];
    plantsPerRow.adjustsFontSizeToFitWidth = YES;
    plantsPerRow.minimumScaleFactor = 0;
    if (([GloablObjects instance].myGarden.width) < 7 && !([[self getAPlantObject:p.name] isEqualToDictionary:nil])) {
        plantsPerRow.text = [[self getAPlantObject:p.name] objectForKey:@"Spacing per Square Foot"] ;
    }
    
    //semi transparent background
    self.backgroundimgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*0.05, cell.bounds.size.height*0.05, cell.bounds.size.width*.9, cell.bounds.size.height*.9)];
    self.backgroundimgview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    //sets plant image and its properties for each square
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", p.name, @"png"] lowercaseString] ;
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.30, cell.bounds.size.height*.3, cell.bounds.size.width*.4, cell.bounds.size.height*.4)];
    imgview.image = [ UIImage imageNamed: imgName];
    [cell.contentView addSubview:self.backgroundimgview];
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:imgview];
    [cell.contentView addSubview:plantsPerRow];
    
    return cell;
}

//called when items are selected from the collection view
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.brushIsInit) {
        //sets the lastclicked index to be used throughout the class
        self.clickedIndex = indexPath.row;
        
        //checks if imcompatable plants with what your planting are near
        [self checkfoes:indexPath.row];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //sets title and their properties for each square
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.05, cell.bounds.size.width*.65, cell.bounds.size.width*.9, 40)];
        title.textColor = [UIColor whiteColor];
        [title setTextAlignment:NSTextAlignmentCenter];
        title.adjustsFontSizeToFitWidth = YES;
        title.minimumScaleFactor = 0;
        title.text = @"";
        if (([GloablObjects instance].myGarden.width) < 7) {
            title.text = [GloablObjects paintBrushInstance].paintBrush.name;
        }
        
        //sets number to plant per sq/ft and the texts properties for each square
        UILabel *plantsPerRow = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.05, cell.bounds.size.width*.01, cell.bounds.size.width*.9, 40)];
        plantsPerRow.textColor = [UIColor whiteColor];
        [plantsPerRow setTextAlignment:NSTextAlignmentCenter];
        [plantsPerRow setFont: [plantsPerRow.font fontWithSize: 13]];
        plantsPerRow.adjustsFontSizeToFitWidth = YES;
        plantsPerRow.minimumScaleFactor = 0;
        if (([GloablObjects instance].myGarden.width) < 7 && !([[self getAPlantObject:[GloablObjects paintBrushInstance].paintBrush.name] isEqualToDictionary:nil])) {
            plantsPerRow.text = [[self getAPlantObject:[GloablObjects paintBrushInstance].paintBrush.name] objectForKey:@"Spacing per Square Foot"];
        }
        
        //semi transparent background
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*.30, cell.bounds.size.height*.3, cell.bounds.size.width*.4, cell.bounds.size.height*.4)];
        self.backgroundimgview = [[UIImageView alloc]initWithFrame:CGRectMake(cell.bounds.size.width*0.05, cell.bounds.size.height*0.05, cell.bounds.size.width*.9, cell.bounds.size.height*.9)];
        self.backgroundimgview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [GloablObjects paintBrushInstance].paintBrush.name, @"png"] lowercaseString] ;
        imgview.image = [ UIImage imageNamed: imgName];
        [cell.contentView addSubview:self.backgroundimgview];
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:imgview];
        [cell.contentView addSubview:plantsPerRow];
        
        //updates garden object
        [[GloablObjects instance].myGarden.gardenArr2d replaceObjectAtIndex:indexPath.row withObject:[GloablObjects paintBrushInstance].paintBrush];
        [self updateUserDefaults];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[GloablObjects plantDataInstance].plantData plantsDataArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: @"Cell" ];
    }
    
    //puts image of plant next to name
    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    cell.imageView.image = [UIImage imageNamed:imgName];
    CGSize itemSize = CGSizeMake(32, 32);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //sets label for cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"", [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row]] ;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // Set subtitles consisting of how many of each plant
    NSString * txt = @"";
    NSString* plantName = [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row];
    if ([[self getAPlantObject:plantName] objectForKey:@"Spacing per Square Foot"]) {
        txt =  [[self getAPlantObject:plantName] objectForKey:@"Spacing per Square Foot"] ;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@" %@%@", txt, @""];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:(124/255.0f) green:(186/255.0f) blue:(37/255.0f) alpha:(1.0f)];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set background back to the original one when tableview is selected
    self.brushIsInit = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.delmode = NO;
    PlantObject* brush = [PlantObject alloc];
    brush.name = [[GloablObjects plantDataInstance].plantData getAPlantName:indexPath.row];
    self.brushIndex = indexPath.row;
    [GloablObjects paintBrushInstance].paintBrush = brush;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



-(NSMutableDictionary *)getAPlantObject: (NSString *) thePlantName {
    for (int i = 0; i < [[GloablObjects plantDataInstance].plantData plantsDataArray].count; i++) {
        NSString * gottenName = [[GloablObjects plantDataInstance].plantData getAPlantName:i];
        if ([gottenName isEqualToString: thePlantName]) {
            return [[GloablObjects plantDataInstance].plantData getAPlant:i];
        }
    }
    return nil;
}

-(bool)checkfoes:(int) index {
    NSString * neighborName = @"";
    NSString *foes = [[GloablObjects plantDataInstance].plantData getAPlantFoes:self.brushIndex];
    PlantObject *plant = [[GloablObjects instance].myGarden.gardenArr2d objectAtIndex:0];
    NSMutableString * message = [NSMutableString stringWithCapacity:1000];
    BOOL found = false;
    
    message = [NSMutableString stringWithFormat:@"%@%@", [[GloablObjects plantDataInstance].plantData getAPlantName:self.brushIndex], @" doesn't grow well with: "];
    
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
    if(!self.delmode){
        self.alert = 1;
        if (found) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMBATIVE WARNING!"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Undo"
                                                  otherButtonTitles:@"Continue",nil];
            //image in alertview
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
            image.contentMode = UIViewContentModeScaleAspectFit;
            
            NSString *loc = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"scaredTomato_100tall.png"]];
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:loc];
            [image setImage:img];
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                [alert setValue:image forKey:@"accessoryView"];
            }else{
                [alert addSubview:image];
            }
            
            [alert show];
            
        }
    }
    return found;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alert == 0) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.brushIndex inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            PlantObject *myPlant = [PlantObject new];
            myPlant.name = @"";
            [GloablObjects paintBrushInstance].paintBrush = myPlant;
            [self.collectionView reloadData];
        } else {
            // Set background back to the original one when cancel button is selected
            self.collectionView.backgroundColor = [UIColor clearColor];
            //[collectionView reloadData];
        }
    } else if (self.alert == 1) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            //hit okay
        } else {
            PlantObject *myPlant = [PlantObject new];
            myPlant.name = @"";
            [[GloablObjects instance].myGarden.gardenArr2d replaceObjectAtIndex:self.clickedIndex withObject:myPlant];
            [self.collectionView reloadData];
        }
    }
}

-(void) notifyUser: (NSString *) notificationMsg {
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:notificationMsg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}



-(IBAction) removeTool: (id) sender {
    // red background when remove button clicked
    self.collectionView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
    self.delmode = YES;
    self.alert = 0;
    dispatch_once (&onceToken, ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                        message:@"You are about to remove plants from your garden! Are you sure you to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue",nil];
        //image in alertview
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *loc = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"shovelBigClear.png"]];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:loc];
        [image setImage:img];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [alert setValue:image forKey:@"accessoryView"];
        }else{
            [alert addSubview:image];
        }
        
        [alert show];
    });
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.brushIndex inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlantObject *myPlant = [PlantObject new];
    myPlant.name = @"";
    [GloablObjects paintBrushInstance].paintBrush = myPlant;
    [self.collectionView reloadData];
}

-(UIImage *)capture{
    [self.collectionView reloadData];
    
    CGRect frame = self.collectionView.frame;
    frame.size.height = self.collectionView.contentSize.height;
    self.collectionView.frame = frame;
    UIGraphicsBeginImageContextWithOptions(self.collectionView.bounds.size, self.collectionView.opaque, 4.0);
    [self.collectionView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

-(IBAction) takePhoto: (id) sender {
    
    self.shot.hidden = NO;
    self.shot.alpha = 1.0f;
    [self.shot setNeedsDisplay];
    [self notifyUser:@"Photo is saved in your Photos"];
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        self.shot.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.shot.image = nil;
        self.shot.hidden = YES;
    }];

    self.shot.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    self.shot.image = [self capture];
    // Save image.
    UIImageWriteToSavedPhotosAlbum(self.shot.image, nil, nil, nil);
    [self.view addSubview:self.collectionView] ;
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
    [self.view addSubview:self.collectionView] ;
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
    [self.view addSubview:self.collectionView] ;
}

-(IBAction) modifyGarden: (id) sender {
    [self performSegueWithIdentifier:@"showModify" sender:self];
}

-(IBAction) goAllGardens: (id) sender {
    //will only work sometimes without called both, you NEED to call both
    [self.navigationController.presentingViewController.presentingViewController viewWillAppear:YES];
    [self.navigationController.presentingViewController.presentingViewController viewDidAppear:YES];
    
    //checks which nav controller needs to be dismissed
    if (self.navigationController.presentingViewController.presentingViewController) {
        [self.navigationController.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void) updateUserDefaults {
    //uses parallell arrays to store garden info
    NSMutableArray *gardens = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenNames = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenWidth = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    NSMutableArray *gardenHeight = [NSMutableArray arrayWithCapacity:[[GloablObjects gardenArrayInstance].gardenArray count]];
    
    //populates above arrays
    for (GardenObject * gard in [GloablObjects gardenArrayInstance].gardenArray) {
        [gardenNames addObject:gard.name];
        NSNumber *w = [NSNumber numberWithInteger:gard.width];
        NSNumber *h = [NSNumber numberWithInteger:gard.height];
        [gardenHeight addObject:w];
        [gardenWidth addObject:h];
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
    
    //writes information to user defaults
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
    
    //uses parallell arrays to store garden info
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gardens = [userDefaults objectForKey:@"gardens"];
    NSMutableArray *gardenNames = [userDefaults objectForKey:@"gardenNames"];
    NSMutableArray *gardenWidth = [userDefaults objectForKey:@"gardenWidth"];
    NSMutableArray *gardenHeight = [userDefaults objectForKey:@"gardenHeight"];
    
    //gets information from user defaults using above arrays
    if (gardens != nil && gardenNames != nil) {
        int i = 0;
        for (NSMutableArray * gard in gardens) {
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self viewDidLoad];
        [self.collectionView reloadData];
        [self.view setNeedsDisplay];
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self viewDidLoad];
        [self.collectionView reloadData];
        [self.view setNeedsDisplay];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.collectionView.backgroundColor = [UIColor clearColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end
