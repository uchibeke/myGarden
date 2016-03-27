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

@interface ViewController () {
    IBOutlet UITableView *myTable;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //sets title bar
    [self setTitle:@"My Gardens"];
    
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *gardens = [userDefaults objectForKey:@"gardens"];
        if (gardens == nil) {
            NSLog(@"gardens not found. creating new instance.");
            [GloablObjects gardenArrayInstance].gardenArray = [[NSMutableArray alloc] init];
            [userDefaults setObject:[GloablObjects gardenArrayInstance].gardenArray forKey:@"gardenArray"];
            [userDefaults synchronize];
        } else {
            [self getFromUserDefaults];
        }
        
        if ([userDefaults objectForKey:@"commentsArray"] == nil) {
            NSLog(@"comments not found.");
            [GloablObjects commentsInstance].commentsArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 50; i++) {
                NSString *test = @"";
                [[GloablObjects commentsInstance].commentsArray addObject:test];
                NSLog(test);
            }
            [userDefaults setObject:[GloablObjects commentsInstance].commentsArray forKey:@"commentsArray"];
            [userDefaults synchronize];
        } else {
            NSLog(@"comments found");
            [GloablObjects commentsInstance].commentsArray = [userDefaults objectForKey:@"commentsArray"];
            for (NSString *s in [GloablObjects commentsInstance].commentsArray) {
                //NSLog(s);
            }
        }
        
        [GloablObjects paintBrushInstance].paintBrush = [[PlantObject alloc] init];
        [GloablObjects notesInstance].notesArray = [[NSMutableArray alloc] init];
        [GloablObjects alarmInstance].alarmArray = [[NSMutableArray alloc] init];
        
        NSLog(@"test");
    });
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"data reload");
    [myTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"data reload");
    [myTable reloadData];
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
    [self updateUserDefaults];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.	
}

@end
