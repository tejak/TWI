//
//  SettingsViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 2/15/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <Social/Social.h>

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userPointsTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabelFS;
@property (weak, nonatomic) IBOutlet UITextField *userPointsTextFieldFS;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserDetails];
}

- (void) getUserDetails {
    
    NSString *tempUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    self.userNameLabel.text = tempUser;
    self.userNameLabelFS.text = tempUser;
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:tempUser];
    
    NSArray *usernamesArray = [query findObjects];
    NSUInteger noOfUsers = [usernamesArray count];
    if (noOfUsers == 1){
        PFObject *object = [usernamesArray objectAtIndex:0];
        NSString *numberPosted = [object valueForKey:@"numberPosted"];
        NSString *numberVerified = [object valueForKey:@"numberVerified"];
        int score = 0;
        if(numberPosted != nil && (![numberPosted isEqualToString:@""])){
            score = [numberPosted intValue] * 10;
        }
        if(numberVerified != nil && (![numberVerified isEqualToString:@""])){
            score = score + [numberVerified intValue] * 5;
        }
        
        NSString *points = [NSString stringWithFormat:@"My points: %d", score];
        self.userPointsTextField.text = points;
        self.userPointsTextFieldFS.text = points;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postOnFbDR:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *facebook = [[SLComposeViewController alloc]init];
        facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *facebookText = ([NSString stringWithFormat:@"%@: %@", self.userNameLabel.text, self.userPointsTextField.text]);
        [facebook setInitialText:facebookText];
        UIImage *waterBoyImage = [UIImage imageNamed:@"Waterboy_full_black.png"];
        [facebook addImage:waterBoyImage];
        [self presentViewController:facebook animated:YES completion:nil];
    }
    else{
        UIAlertView *alertNotLoggedIn = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You're not logged into Facebook" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertNotLoggedIn show];
    }
}

- (IBAction)postOnTwDR:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *twitter = [[SLComposeViewController alloc] init];
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *twitterText = ([NSString stringWithFormat:@"%@: %@", self.userNameLabel.text, self.userPointsTextField.text]);
        [twitter setInitialText:twitterText];
        UIImage *waterBoyImage = [UIImage imageNamed:@"Waterboy_full_black.png"];
        [twitter addImage:waterBoyImage];
        [self presentViewController:twitter animated:YES completion:nil];
    }
    else{
        UIAlertView *alertNotLoggedIn = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You're not logged into Twitter" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertNotLoggedIn show];
    }
}

- (IBAction)postOnFbFS:(id)sender {
    SLComposeViewController *facebook;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        facebook = [[SLComposeViewController alloc]init];
        facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *facebookText = ([NSString stringWithFormat:@"%@: %@", self.userNameLabelFS.text, self.userPointsTextFieldFS.text]);
        [facebook setInitialText:facebookText];
        UIImage *waterBoyImage = [UIImage imageNamed:@"Waterboy_full_black.png"];
        [facebook addImage:waterBoyImage];
        
        [self presentViewController:facebook animated:YES completion:nil];
        
    }
    else{
        UIAlertView *alertNotLoggedIn = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You're not logged into Facebook" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertNotLoggedIn show];
    }
   
    [facebook setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];

}

- (IBAction)postOnTwFS:(id)sender {
    SLComposeViewController *twitter;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        twitter = [[SLComposeViewController alloc] init];
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *twitterText = ([NSString stringWithFormat:@"%@: %@", self.userNameLabelFS.text, self.userPointsTextFieldFS.text]);
        [twitter setInitialText:twitterText];
        UIImage *waterBoyImage = [UIImage imageNamed:@"Waterboy_full_black.png"];
        [twitter addImage:waterBoyImage];
        [self presentViewController:twitter animated:YES completion:nil];
    }
    else{
        UIAlertView *alertNotLoggedIn = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You're not logged into Twitter" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertNotLoggedIn show];
    }
    
    [twitter setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    

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
