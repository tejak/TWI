//
//  AllUserReviewsViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 3/4/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "AllUserReviewsViewController.h"

@interface AllUserReviewsViewController ()
@property(nonatomic, strong) NSMutableArray *allContaminants;
@property(nonatomic, strong) NSMutableDictionary *contaminantDictionary;
@property(nonatomic, strong) NSMutableArray *colorCoding;
@end

@implementation AllUserReviewsViewController

- (void)initializeContaminantDictionary{
    self.contaminantDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"Alabama",@"AL",
                              @"Alaska",@"AK",
                              @"Arizona",@"AZ",
                              @"Arkansas",@"AR",
                              @"California",@"CA",
                              @"Colorado",@"CO",
                              @"Connecticut",@"CT",
                              @"Delaware",@"DE",
                              @"District Of Columbia",@"DC",
                              @"Florida",@"FL",
                              @"Georgia",@"GA",
                              @"Hawaii",@"HI",
                              @"Idaho",@"ID",
                              @"Illinois",@"IL",
                              @"Indiana",@"IN",
                              @"Iowa",@"IA",
                              @"Kansas",@"KS",
                              @"Kentucky",@"KY",
                              @"Louisiana",@"LA",
                              @"Maine",@"ME",
                              @"Maryland",@"MD",
                              @"Massachusetts",@"MA",
                              @"Michigan",@"MI",
                              @"Minnesota",@"MN",
                              @"Mississippi",@"MS",
                              @"Missouri",@"MO",
                              @"Montana",@"MT",
                              @"Nebraska",@"NE",
                              @"Nevada",@"NV",
                              @"New Hampshire",@"NH",
                              @"New Jersey",@"NJ",
                              @"New Mexico",@"NM",
                              @"New York",@"NY",
                              @"North Carolina",@"NC",
                              @"North Dakota",@"ND",
                              @"Ohio",@"OH",
                              @"Oklahoma",@"OK",
                              @"Oregon",@"OR",
                              @"Pennsylvania",@"PA",
                              @"Rhode Island",@"RI",
                              @"South Carolina",@"SC",
                              @"South Dakota",@"SD",
                              @"Tennessee",@"TN",
                              @"Texas",@"TX",
                              @"Utah",@"UT",
                              @"Vermont",@"VT",
                              @"Virginia",@"VA",
                              @"Washington",@"WA",
                              @"West Virginia",@"WV",
                              @"Wisconsin",@"WI",
                              @"Wyoming",@"WY",
                              nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeContaminantDictionary];
    
    self.allContaminants = [[NSMutableArray alloc]init];
    self.allContaminants = [[NSUserDefaults standardUserDefaults] objectForKey:@"allContaminants"];
    NSLog(@"%@", self.allContaminants);
}

// Methods for table view 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allContaminants count];
}

// Methods for table view 2
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    // Set this to get from array
    cell.textLabel.text = [self.allContaminants objectAtIndex:indexPath.row];
    //cell.backgroundColor = [self.colorCoding objectAtIndex:indexPath.row];
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
