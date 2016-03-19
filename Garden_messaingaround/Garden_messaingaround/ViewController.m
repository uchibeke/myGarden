//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewController.h"
#import "PlantObject.h"
#import "GloablObjects.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //sets title bar
    [self setTitle:@"My Gardens"];
    
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [GloablObjects gardenArrayInstance].gardenArray = [[NSMutableArray alloc] init];
        [GloablObjects paintBrushInstance].paintBrush = [[PlantObject alloc] init];
        [GloablObjects notesInstance].notesArray = [[NSMutableArray alloc] init];
        NSLog(@"test");
    });
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    [[GloablObjects gardenArrayInstance].gardenArray removeObjectAtIndex:indexPath.row ];
    [tableView reloadData];
}



//action tied to creat new garden button
//loads new view, which asks for info then creates new garden
-(IBAction) createNewGarden: (id) sender {
    [GloablObjects instance].myGarden = nil;
    //must link views togther first, and set identifer
    [self performSegueWithIdentifier:@"modalCreate" sender:self];
}


//had to link the tableview delegate and datasource in the storyboard, via the inspecter
//in order to assiosiate the tableview with the 3 functions below
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //returns sections, no sections nessesary as its just a list of gardens
    return( 1 );
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //returns the amount of 'cells' in the sections
    return [GloablObjects gardenArrayInstance].gardenArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    
    if ( cell == nil )
    {
        cell = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"Cell" ];
    }
    
    //setting the cell textlabel sets each indiidual cells text
    GardenObject* myObject = [GloablObjects gardenArrayInstance].gardenArray[indexPath.row];
    
    cell.textLabel.text = myObject.name;
    
    NSString * imgName = @"gardenIconWhite.png";
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [GloablObjects instance].myGarden = [GloablObjects gardenArrayInstance].gardenArray[indexPath.row];
    
    //loads new view
    [self performSegueWithIdentifier:@"showTabs" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.	
}

@end
