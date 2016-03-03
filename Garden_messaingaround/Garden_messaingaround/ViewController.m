//
//  ViewController.m
//  Garden_messaingaround
//
//  Created by wyatt grant on 2016-02-27.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewController.h"
#import "PlantObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //sets title bar
    [self setTitle:@"My Gardens"];
    
    //init garden
    self.arrayOfGardens = [ NSMutableArray new ];
    
    //add elements to array which holds garden objects defined in the header file
    [self.arrayOfGardens addObject:@"dummy garden 1"];
    [self.arrayOfGardens addObject:@"dummy garden 2"];
    [self.arrayOfGardens addObject:@"dummy garden 3"];    
    
}


//action tied to creat new garden button
//loads new view, which asks for info then creates new garden
-(IBAction) createNewGarden: (id) sender {
    //must link views togther first, and set identifer
    [self performSegueWithIdentifier:@"showNewGarden" sender:self];
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
    //log varifies amount
    NSLog(@"count:%lu", (unsigned long)self.arrayOfGardens.count);
    return self.arrayOfGardens.count;
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
    NSString* myObject = self.arrayOfGardens[indexPath.row];
    
    cell.textLabel.text = myObject;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.	
}

@end
