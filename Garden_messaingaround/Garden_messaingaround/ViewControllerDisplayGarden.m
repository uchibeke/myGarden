
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
//    IBOutlet UITableView * tableView;
}

@property GardenObject * garden;

@end

@implementation ViewControllerDisplayGarden


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //sets title bar
    [self setTitle:[GloablObjects instance].myGarden.name];
    
    //dummy garden, bs info
//    self.garden = [[GardenObject alloc] init];
//    [self.garden allocateTable:4 withWidth:9];
    //self.garden = [GloablObjects instance].myGarden;
    
    UICollectionViewFlowLayout *layout = (id) collectionView.collectionViewLayout;
    
    float screenWidth = layout.collectionViewContentSize.width;
    float widthOfCell = (screenWidth)/([[GloablObjects instance].myGarden getWidth])-1;
    
    layout.itemSize = CGSizeMake(widthOfCell, widthOfCell);
    
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 1.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
//    I'm doing the allocation of the plant here. We might need to refactor this later
    self.plant = [[PlantObject alloc]init];
    
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
    return cell;
}

//http://stackoverflow.com/questions/18857167/uicollectionview-cell-selection

//called when items are selected from the collection view
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/2, cell.bounds.size.width, 40)];
    title.textColor = [UIColor purpleColor];
    title.text = [GloablObjects paintBrushInstance].paintBrush.name;
    UIImageView *imgview = [[UIImageView alloc]init];
    
    [cell.contentView addSubview:imgview];
    
    
    [ [self.plant usersPlants] addObject:[GloablObjects paintBrushInstance].paintBrush];
    NSInteger addedIndex = [self.plant usersPlants].count-1;
    NSLog([NSString stringWithFormat:@"Added Object: %@",[[[self.plant usersPlants] objectAtIndex:addedIndex]name] ]);
    
    
    imgview.image = [ UIImage imageNamed: [GloablObjects paintBrushInstance].paintBrush.name];    
    [cell.contentView addSubview:title];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: @"Cell" ];
    }
    // TODO
    // There is a bug when scrolling the tableview. The images do not refresh. My guess is that we need to clear the index when the item is scroll off the screen
    // Currently getting the image from the folder conataining all the images
    // The catch with this method is that the file name must match the plant name.
    // Something we could do with the file name is that if a plant has two words as a name,
    // we can name the file something like redPepper.
    // The code below will convert the name to lower case and handle the rest.
    // File must also be png
    
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
    
    PlantObject* brush = [PlantObject alloc];
    brush.name = [self.plant getAPlantName:indexPath.row];
    
    [GloablObjects paintBrushInstance].paintBrush = brush;
    
    NSLog([GloablObjects paintBrushInstance].paintBrush.name);
}

// Size of the cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
