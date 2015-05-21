//
//  ViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 12/26/14.
//  Copyright (c) 2014 J. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Clear NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // Navigate
    [self performSelector:@selector(loadingNextView)
               withObject:nil afterDelay:3.0f];
    
}

- (void)loadingNextView{
    [[NSUserDefaults standardUserDefaults] setObject:@"GUEST" forKey:@"currentUser"];
    [self performSegueWithIdentifier:@"toMain" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
