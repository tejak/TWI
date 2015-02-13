//
//  LoginViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 12/26/14.
//  Copyright (c) 2014 J. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
// User login
@property (strong, nonatomic) IBOutlet UITextField *inputUsername;
@property (strong, nonatomic) IBOutlet UITextField *inputPassword;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Format UI
    //self.inputUsername.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)logInClicked:(id)sender {
    [self userLogin];
}

- (void)userLogin{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:self.inputUsername.text];
    [query whereKey:@"password" equalTo:self.inputPassword.text];
    
    NSArray *usernamesArray = [query findObjects];
    NSUInteger noOfUsers = [usernamesArray count];
    if (noOfUsers == 1){
        [[NSUserDefaults standardUserDefaults] setObject:self.inputUsername.text forKey:@"currentUser"];
        [self performSegueWithIdentifier:@"loginTransition" sender:self];
    }else{
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Login not successful" message:@"Incorrect username or password" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
}

- (IBAction)continueAsGuestClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"GUEST" forKey:@"currentUser"];
    [self performSegueWithIdentifier:@"loginTransition" sender:self];
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
