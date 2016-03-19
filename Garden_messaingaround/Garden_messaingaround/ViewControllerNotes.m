//
//  ViewControllerNotes.m
//  Garden_messaingaround
//
//  Created by Stephanie Dilsner on 2016-03-12.
//  Copyright (c) 2016 wyatt grant. All rights reserved.
//

#import "ViewControllerNotes.h"

@interface ViewControllerNotes () {
    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *saveBtn;
    IBOutlet UITextView * notesField;
    NSInteger clickedIndex;
    BOOL justDel;
    
    
}

@end

@implementation ViewControllerNotes

//-(IBAction) saveNote: (id) sender {/
  //  [[GloablObjects notesInstance].notesArray replaceObjectAtIndex:clickedIndex withObject:notesField.text];
//    NSLog([NSString stringWithFormat:@"%ld", (long)clickedIndex]);

//    [tableView reloadData];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self saveNote];
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
    [[GloablObjects notesInstance].notesArray removeObjectAtIndex:indexPath.row ];
    [tableView reloadData];
    [self enableNoteField];
    justDel = true;
    if (clickedIndex == indexPath.row) {
        notesField.text = @"";
        notesField.hidden = true;
    }

    NSLog(@"Deleted row.");
}

-(void)saveNote {
    if([[GloablObjects notesInstance].notesArray count ]> 0 && !justDel) {
        [[GloablObjects notesInstance].notesArray replaceObjectAtIndex:clickedIndex withObject:notesField.text];
        NSLog([NSString stringWithFormat:@"%ld", (long)clickedIndex]);
        [tableView reloadData];
    } else {
        justDel = !justDel;
    }
}


-(void) enableNoteField {
    if([[GloablObjects notesInstance].notesArray count ] == 0) {
        notesField.hidden = TRUE;
    } else {
        notesField.hidden = FALSE;
    }
}

-(IBAction) newNote: (id) sender {
    [self saveNote];
    NSString *note = @"New Note";
    [[GloablObjects notesInstance].notesArray addObject:note];
    notesField.text =[NSString stringWithFormat:@"%@ ...", note];
    [notesField showsHorizontalScrollIndicator];
    [tableView reloadData];
    [self enableNoteField];
    clickedIndex = [GloablObjects notesInstance].notesArray.count-1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return( 1 );
}


- (NSInteger)tableView:(UITableView *)tableView

 numberOfRowsInSection:(NSInteger)section
{
    return [[GloablObjects notesInstance].notesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [ [ UITableViewCell alloc ]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: @"Cell" ];
    }
    
//    NSString * imgName = [[NSString stringWithFormat:@"%@.%@", [self.plant getAPlantName:indexPath.row], @"png"] lowercaseString] ;
    
//    cell.imageView.image = [UIImage imageNamed:imgName];
    
//    CGSize itemSize = CGSizeMake(32, 32);
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [cell.imageView.image drawInRect:imageRect];
//    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    NSInteger upperLimit = 24;
    if ([[[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row] length] < upperLimit) {
        upperLimit = [[[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row] length];
    }
    
    NSString * imgName = [NSString stringWithFormat:@"noteSmall.png"];
    
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    
    
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    cell.textLabel.text = [[[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, upperLimit)] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self saveNote];
    notesField.text = [[GloablObjects notesInstance].notesArray objectAtIndex:indexPath.row];
    clickedIndex = indexPath.row;
    if (clickedIndex > [GloablObjects notesInstance].notesArray.count-1)
        clickedIndex = [GloablObjects notesInstance].notesArray.count-1;
    notesField.hidden = FALSE;
}

// Size of the cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    clickedIndex = 0;
    notesField.text = @"";
    if ([[GloablObjects notesInstance].notesArray count] > 0) {
        notesField.text = [[GloablObjects notesInstance].notesArray objectAtIndex:0];
    }
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-texture-background.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirt3brown"]];
    [self enableNoteField  ];
    justDel = false;
    

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

@end
