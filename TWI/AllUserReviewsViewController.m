//
//  AllUserReviewsViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 3/4/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "AllUserReviewsViewController.h"

@interface AllUserReviewsViewController ()
@property(nonatomic, strong) NSMutableArray *allUserReviews;
@end

@implementation AllUserReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set coming back
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"comingBackFromReviews"];
    
    self.allUserReviews = [[NSMutableArray alloc]init];
    self.allUserReviews = [[NSUserDefaults standardUserDefaults] objectForKey:@"userReviews"];
    NSLog(@"%@", self.allUserReviews);
}

// Methods for table view 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allUserReviews count];
}

// Methods for table view 2
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    // Set this to get from array
    cell.textLabel.text = [self.allUserReviews objectAtIndex:indexPath.row];
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
