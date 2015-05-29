//
//  SignUpViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 12/26/14.
//  Copyright (c) 2014 J. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
// User Sign up
@property (strong, nonatomic) IBOutlet UITextField *emailSignup;
@property (strong, nonatomic) IBOutlet UITextField *usernameSignup;
@property (strong, nonatomic) IBOutlet UITextField *passwordSignup;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUpClicked:(id)sender {
    [self createUser];
}

- (void)createUser{
    
    if(self.usernameSignup.text == nil || self.emailSignup.text == nil || self.passwordSignup == nil){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Details missing" message:@"Please enter all data to sign up" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    else if ([self.usernameSignup.text isEqualToString:@"GUEST"]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Username not permitted" message:@"Please choose a different username" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    else{
        NSString *trimmedString = [self.usernameSignup.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *lowerCaseUsername = [trimmedString lowercaseString];
        
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"username" equalTo:lowerCaseUsername];
        NSArray *existingUsernames = [query findObjects];
        
        if([existingUsernames count] == 0){
            PFQuery *emailQuery = [PFQuery queryWithClassName:@"User"];
            [emailQuery whereKey:@"email" equalTo:self.emailSignup.text];
            
            NSArray *existingEmails = [emailQuery findObjects];
            if([existingEmails count] == 0){
                PFObject *user = [PFObject objectWithClassName:@"User"];
                user[@"username"] = lowerCaseUsername;
                user[@"password"] = self.passwordSignup.text;
                user[@"email"] = self.emailSignup.text;
                [user save];
                UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Sign up successful" message:@"You're signed up! Go back to login to continue!" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
                [alertsuccess show];
                self.usernameSignup.text = @"";
                self.passwordSignup.text = @"";
                self.emailSignup.text = @"";
            }else{
                UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"User exists" message:@"User with this email exists. Please try a different email" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
                [alertsuccess show];
            }
            
        }else{
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"User exists" message:@"User already exists. Please try a different username" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
            [alertsuccess show];
        }
    }
}

- (IBAction)returnButtonPressed:(id)sender {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameSignup resignFirstResponder];
    [self.passwordSignup resignFirstResponder];
    [self.emailSignup resignFirstResponder];
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
