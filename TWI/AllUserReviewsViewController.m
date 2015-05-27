//
//  AllUserReviewsViewController.m
//  TWI
//  Althought this class is called AllUserReviews, it displays contaminants list
//
//  Created by Jamini Sampathkumar on 3/4/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "AllUserReviewsViewController.h"

@interface AllUserReviewsViewController ()
@property(nonatomic, strong) NSMutableDictionary *contaminantDictionary;
@property(nonatomic, strong) NSMutableArray *allContaminants;
@property(nonatomic, strong) NSMutableArray *colorCoding;
@property(nonatomic, strong) NSMutableArray *sortedContaminants;
@property(nonatomic, strong) NSMutableArray *contaminantLevel;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation AllUserReviewsViewController

- (void)initializeContaminantDictionary{
    self.contaminantDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"3",@"Aluminium",
                                  @"4",@"Arsenic",
                                  @"4",@"Asbestos",
                                  @"2",@"Atrazine",
                                  @"4",@"Benzene",
                                  @"2",@"Bromide",
                                  @"2",@"Butane",
                                  @"2",@"Cadmium",
                                  @"1",@"Chlorine",
                                  @"2",@"Chloroethane",
                                  @"4",@"Chloroform",
                                  @"4",@"Chromium (total)",
                                  @"1",@"Copper",
                                  @"4",@"Dieldrin",
                                  @"4",@"Flouride",
                                  @"2",@"Lead (total)",
                                  @"3",@"Lithium",
                                  @"3",@"Mercury (total inorganic)",
                                  @"3",@"MTBE",
                                  @"1",@"Nickel",
                                  @"3",@"Nitrate",
                                  @"3",@"Nitrite",
                                  @"3",@"Total haloacetic acids ",
                                  @"3",@"Total trihalomethanes ",
                                  nil];
    
}


- (void) generateColorCode{
    self.colorCoding = [[NSMutableArray alloc]init];
    for (NSString *eachContaminant in self.allContaminants){
        NSString *colorExtent = [self.contaminantDictionary objectForKey:eachContaminant];
        if(colorExtent == nil){
            [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1]];
        }else if([colorExtent isEqualToString:@"1"]){
            [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1]]; /*#ffcc00*/
        }else if([colorExtent isEqualToString:@"2"]){
            [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.6 blue:0 alpha:1]]; /*#ff9900*/
        }else if([colorExtent isEqualToString:@"3"]){
            [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.4 blue:0 alpha:1]]; /*#ff6600*/
        }else if([colorExtent isEqualToString:@"4"]){
            [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.2 blue:0 alpha:1]]; /*#ff3300*/
        }else{
            [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.2 blue:0 alpha:1]]; /*#ff3300*/
        }
    }
}

- (void) sortContaminantsAndColor {
    self.sortedContaminants = [[NSMutableArray alloc]init];
    self.colorCoding = [[NSMutableArray alloc]init];
    self.contaminantLevel = [[NSMutableArray alloc]init];
    
    for (NSString *eachContaminant in self.allContaminants){
        NSString *colorExtent = [self.contaminantDictionary objectForKey:eachContaminant];
        if(colorExtent == nil || [colorExtent isEqualToString:@"4"]){
            NSString *tempContaminant = eachContaminant;
            if ([eachContaminant isEqualToString:@"Chromium (total)"]){
                tempContaminant = @"Chromium";
            }
            
            if ([self.sortedContaminants indexOfObject:tempContaminant]== NSNotFound){
                [self.sortedContaminants addObject:tempContaminant];
                [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.2 blue:0 alpha:1]]; /*#ff3300*/
                //[self.contaminantLevel addObject:@"Highly dangerous"];
                [self.contaminantLevel addObject:@"Level 4"];

            }
        }
    }
    
    for (NSString *eachContaminant in self.allContaminants){
        NSString *colorExtent = [self.contaminantDictionary objectForKey:eachContaminant];
        if(colorExtent != nil && [colorExtent isEqualToString:@"3"]){
            NSString *tempContaminant = eachContaminant;
            if ([eachContaminant isEqualToString:@"Mercury (total inorganic)"]){
                tempContaminant = @"Mercury";
            }
            if ([self.sortedContaminants indexOfObject:tempContaminant]== NSNotFound){
                [self.sortedContaminants addObject:tempContaminant];
                [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.4 blue:0 alpha:1]]; /*#ff6600*/
                //[self.contaminantLevel addObject:@"Dangerous"];
                [self.contaminantLevel addObject:@"Level 3"];
            }
        }
    }
    
    for (NSString *eachContaminant in self.allContaminants){
        NSString *colorExtent = [self.contaminantDictionary objectForKey:eachContaminant];
        if(colorExtent != nil && [colorExtent isEqualToString:@"2"]){
            NSString *tempContaminant = eachContaminant;
            if ([eachContaminant isEqualToString:@"Lead (total)"]){
                tempContaminant = @"Lead";
            }
            if ([self.sortedContaminants indexOfObject:tempContaminant]== NSNotFound){
                [self.sortedContaminants addObject:tempContaminant];
                [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.6 blue:0 alpha:1]]; /*#ff9900*/
                //[self.contaminantLevel addObject:@"Moderately dangerous"];
                [self.contaminantLevel addObject:@"Level 2"];
            }
        }
    }
    
    for (NSString *eachContaminant in self.allContaminants){
        NSString *colorExtent = [self.contaminantDictionary objectForKey:eachContaminant];
        if(colorExtent != nil && [colorExtent isEqualToString:@"1"]){
            if ([self.sortedContaminants indexOfObject:eachContaminant]== NSNotFound){
                [self.sortedContaminants addObject:eachContaminant];
                [self.colorCoding addObject:[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1]]; /*#ffcc00*/
                //[self.contaminantLevel addObject:@"Less dangerous"];
                [self.contaminantLevel addObject:@"Level 1"];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allContaminants = [[NSMutableArray alloc]init];
    self.allContaminants = [[NSUserDefaults standardUserDefaults] objectForKey:@"allContaminants"];
    
    [self initializeContaminantDictionary];
    [self sortContaminantsAndColor];
    
    // Set login & settings button
    NSString *tempUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    if (tempUser == nil || [tempUser isEqualToString:@""] || [tempUser isEqualToString:@"GUEST"]){
        self.loginButton.hidden = NO;
        self.settingsButton.hidden = YES;
    }else{
        self.loginButton.hidden = YES;
        self.settingsButton.hidden = NO;
    }

    
}

// Methods for table view 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sortedContaminants count];
}

// Methods for table view 2
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    // Set this to get from array
    cell.textLabel.text = [self.sortedContaminants objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.contaminantLevel objectAtIndex:indexPath.row];
    cell.backgroundColor = [self.colorCoding objectAtIndex:indexPath.row];
    return cell;
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
