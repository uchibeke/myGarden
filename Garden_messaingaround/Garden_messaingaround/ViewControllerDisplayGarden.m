
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

@interface ViewControllerDisplayGarden () {
    IBOutlet UICollectionView *collectionView;
    IBOutlet UITableView *tableView;
    UIImageView *backgroundimgview;
    
    int alert;

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
    
    //dummy garden, bs info
//    self.garden = [[GardenObject alloc] init];
//    [self.garden allocateTable:4 withWidth:9];
    //self.garden = [GloablObjects instance].myGarden;
    UICollectionViewFlowLayout *layout = (id) collectionView.collectionViewLayout;
    
    float screenWidth = layout.collectionViewContentSize.width;
    float widthOfCell = (screenWidth)/([[GloablObjects instance].myGarden getWidth])-1;
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenW = screenRect.size.width;
//    CGFloat screenH = screenRect.size.height;
    
    layout.itemSize = CGSizeMake(widthOfCell, widthOfCell);
    
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 1.0f;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    [self createScrollView:collectionView.frame.size.width
                 andHeight:collectionView.frame.size.height
                   startAt:collectionView.frame.origin.x
                     endAt:collectionView.frame.origin.y];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.plant = [[PlantObject alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    [self.plant saveGardenToFile:[self.plant plantsDataArray] gardenName:@"testArr" ];
    [self.plant getSavedGardenFromFile:@"testArr"];
    NSLog(@"Get Link is: %@\n ", [self.plant getSavedGardenFromFile:@"testArr"]);

    

    
    self.tabBarItem.image = [[UIImage imageNamed:@"noteSmall.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSArray *documents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    
//    http://stackoverflow.com/questions/4934389/storing-json-data-on-the-iphone-save-the-json-string-as-it-is-vs-make-an-object
    NSURL *URL;
    NSString *completeFilePath;
    for (NSString *file in documents) {
        completeFilePath = [NSString stringWithFormat:@"%@/%@", basePath, file];
        URL = [NSURL fileURLWithPath:completeFilePath];
        NSLog(@"File %@  is excluded from backup %@", file, [URL resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsExcludedFromBackupKey] error:nil]);
    }
    
   // URL = [NSURL fileURLWithPath:completeFilePath];
   // [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    NSLog(@"Doc is: %@\n  Path is: %@", [documents description], basePath);
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


-(bool)checkfoes:(int) index {
    NSLog(@"%d",index);
    NSLog(@"%d",[GloablObjects instance].myGarden.width);
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
    
    alert = 1;
    if (found) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMBATIVE WARNING!"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Undo"
                                              otherButtonTitles:@"Continue",nil];
        [alert show];

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
    
    alert = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                    message:@"You are about to remove plants from your garden! Are you sure you to continue?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Continue",nil];
    [alert show];
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
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil); //if you need to save
//    return imageView;
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    CGSize size = CGSizeMake(screenSize.width, screenSize.width);
//    
//    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//    
//    CGRect rec = CGRectMake(0, 0, screenSize.width, screenSize.width);
//    [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//    
//    
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    [self.parentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    http://stackoverflow.com/questions/14376249/creating-a-uiimage-from-a-uitableview
    
    [collectionView reloadData];
    
    CGRect frame = collectionView.frame;
    frame.size.height = collectionView.contentSize.height;
//    frame.size.width = collectionView.contentSize.width;
    collectionView.frame = frame;
    
    UIGraphicsBeginImageContext(collectionView.bounds.size);
    [collectionView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    
    return image;
}

-(IBAction) takePhoto: (id) sender {
    [shot setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]]];
    shot.image = [self capture];
    [shot setNeedsDisplay];
    shot.hidden = NO;
    shot.alpha = 1.0f;
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        shot.alpha = 0.0f;
    } completion:^(BOOL finished) {
        shot.image = nil;
        shot.hidden = YES;
    }];
    [self.view addSubview:collectionView] ;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
