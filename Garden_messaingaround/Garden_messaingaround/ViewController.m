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
#import "PlantData.h"

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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *gardens = [userDefaults objectForKey:@"gardens"];
        if (gardens == nil) {
            [GloablObjects gardenArrayInstance].gardenArray = [[NSMutableArray alloc] init];
            [userDefaults setObject:[GloablObjects gardenArrayInstance].gardenArray forKey:@"gardenArray"];
            [userDefaults synchronize];
        } else {
            [self getFromUserDefaults];
        }
        
        if ([userDefaults objectForKey:@"commentsArray"] == nil) {
            [GloablObjects commentsInstance].commentsArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 50; i++) {
                NSString *test = @"";
                [[GloablObjects commentsInstance].commentsArray addObject:test];
            }
            [userDefaults setObject:[GloablObjects commentsInstance].commentsArray forKey:@"commentsArray"];
            [userDefaults synchronize];
        } else {
            [GloablObjects commentsInstance].commentsArray = [userDefaults objectForKey:@"commentsArray"];
        }
        
        [GloablObjects paintBrushInstance].paintBrush = [[PlantObject alloc] init];
        [GloablObjects notesInstance].notesArray = [[NSMutableArray alloc] init];
        [GloablObjects alarmInstance].alarmArray = [[NSMutableArray alloc] init];
        [GloablObjects plantDataInstance].plantData = [[PlantData alloc] init];
    });
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];

    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[GloablObjects gardenArrayInstance].gardenArray removeObjectAtIndex:indexPath.row ];
    [self updateUserDefaults];
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
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
    
    GardenObject* myObject = [GloablObjects gardenArrayInstance].gardenArray[indexPath.row];
    
    cell.textLabel.text = myObject.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    NSString * imgName = @"gardenIconWhite.png";
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [GloablObjects instance].myGarden = [GloablObjects gardenArrayInstance].gardenArray[indexPath.row];
    
    [self performSegueWithIdentifier:@"showTabs" sender:self];
}



-(IBAction) createNewGarden: (id) sender {
    [GloablObjects instance].myGarden = nil;
    //must link views togther first, and set identifer
    [self performSegueWithIdentifier:@"modalCreate" sender:self];
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



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myTable reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.	
}

@end
