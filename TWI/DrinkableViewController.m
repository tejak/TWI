//
//  DrinkableViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 12/26/14.
//  Copyright (c) 2014 J. All rights reserved.
//

#import "DrinkableViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface DrinkableViewController ()
// To store in NSUserDefaults
@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) NSString *currentZip;

// Get User Review
@property (strong, nonatomic) NSMutableDictionary *userReviewDictionary;

// Add User Review
@property (strong, nonatomic) NSString *inputDrinkable;
@property (weak, nonatomic) IBOutlet UITextView *reviewText;


// Drinkability
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *twidrinkable;
@property (strong, nonatomic) NSString *localPeepDrinkable;

// Water Pedia
@property (strong, nonatomic) NSString *waterUtility;
@property (strong, nonatomic) NSString *dataEnd;
@property (strong, nonatomic) NSString *noExceedingHealthLimit;

// View Inputs
@property (strong, nonatomic) IBOutlet UITextField *location_text;
@property (strong, nonatomic) NSString *drinkable;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

// Display Drinkability
@property (weak, nonatomic) IBOutlet UIView *drinkabilitySubView;
@property (weak, nonatomic) IBOutlet UIButton *drWaterButton;
@property (weak, nonatomic) IBOutlet UIButton *localPeepButton;
@property (weak, nonatomic) IBOutlet UILabel *drinkabilityLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *drWaterProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *localPeepProgressBar;


// Display Waterpedia
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *waterUtilTextField;
@property (weak, nonatomic) IBOutlet UITextField *noOfContaminantsTextField;
@property (weak, nonatomic) IBOutlet UIView *waterPediaSubView;


// Display User review
@property (weak, nonatomic) IBOutlet UITextField *review1;
@property (weak, nonatomic) IBOutlet UITextField *review2;
@property (weak, nonatomic) IBOutlet UITextField *review3;

@property (weak, nonatomic) IBOutlet UIView *userReviewSubView;
@property (weak, nonatomic) IBOutlet UIButton *addUserReviewButton;
@property (weak, nonatomic) IBOutlet UIView *addUserReviewSubview;
@property (weak, nonatomic) IBOutlet UIView *displayUserReviewSubview;


@property (strong, nonatomic) NSMutableDictionary *nameAbbreviations;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation DrinkableViewController {
    CLLocationManager *locationManager;
    CLLocation *curr_location;
}

- (void)initializeDictionary{
    self.nameAbbreviations = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    
    // Initialize dictionary
    [self initializeDictionary];
    
    // Set default location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)setUpMap {
    float spanX = 0.0125;
    float spanY = 0.0125;
    curr_location = locationManager.location;
    NSLog(@"Initializing the location map first time: %@", curr_location.description); //A quick NSLog to show us that location data is being received.
    MKCoordinateRegion region;
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
}

// And this somewhere in your class that’s mapView’s delegate (most likely a view controller).
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    //if ([overlay isKindOfClass:[MKTileOverlay class]]) {
    return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    //}
    //return nil;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    //CLLocation *currentLocation = newLocation;
    
    if (curr_location == nil){
        [self setUpMap];
        [self reverseGeocode];
    }

    if (self.currentZip == nil || [self.currentZip isEqualToString:@""]){
        self.currentZip = self.location_text.text;
        [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    }
    //NSLog(@"Location text at location manager %@", self.location_text.text);
}

- (void)reverseGeocode {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:curr_location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            self.currentZip = [NSString stringWithFormat:@"%@", placemark.postalCode];
            [[NSUserDefaults standardUserDefaults] setObject:placemark.postalCode forKey:@"currentZip"];
            self.city = [NSString stringWithFormat:@"%@", placemark.locality];
            NSString *tempState = [self.nameAbbreviations objectForKey:placemark.administrativeArea];
            self.state = tempState;
            self.location_text.text = [NSString stringWithFormat:@"%@", placemark.postalCode];
        }
    }];
}


- (IBAction)showresults:(id)sender {
    [self clearExistingSubviews];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.location_text.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            float spanX = 0.0125;
            float spanY = 0.0125;
            self.currentZip = [NSString stringWithFormat:@"%@", self.location_text.text];
            [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
            
            self.city = [NSString stringWithFormat:@"%@", placemark.locality];
            
            NSString *tempState = [self.nameAbbreviations objectForKey:placemark.administrativeArea];
            self.state = tempState;
            
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
        }
    }];
    //NSLog(@"Location text at show results %@", self.location_text.text);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setDrinkabilityImages{
    NSString *tempText = [NSString stringWithFormat:@"Drinkability at %@", self.currentZip];
    self.drinkabilityLabel.text = tempText;
    if(self.twidrinkable == nil){
        UIImage *image = [UIImage imageNamed: @"Gray_drop.png"];
        [self.drWaterButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if([self.twidrinkable isEqualToString:@"YES"]){
        UIImage *image = [UIImage imageNamed: @"Green_drop.png"];
        [self.drWaterButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed: @"Red_drop.png"];
        [self.drWaterButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    if(self.localPeepDrinkable == nil){
        UIImage *image = [UIImage imageNamed: @"Gray_drop.png"];
        [self.localPeepButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if([self.localPeepDrinkable isEqualToString:@"YES"]){
        UIImage *image = [UIImage imageNamed: @"Green_drop.png"];
        [self.localPeepButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed: @"Red_drop.png"];
        [self.localPeepButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    self.drinkabilitySubView.hidden = NO;
}

- (void) getDrinkabilityByLocalPeeps{
    int yesCount = 0;
    int noCount = 0;
    self.userReviewDictionary = [[NSMutableDictionary alloc]init];
    
    // VERIFY CURRENT ZIP
    NSString *tempZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    if(tempZip == nil || [tempZip isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    }
    self.currentZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    if(self.currentZip == nil || [self.currentZip isEqualToString:@""]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter a valid zip code" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }else{
        PFQuery *query = [PFQuery queryWithClassName:@"UserReview"];
        [query whereKey:@"Zipcode" equalTo:self.currentZip];
        NSArray *objects = [query findObjects];
        NSLog(@"Number of reviews: %d", (int)objects.count);
        if(objects.count > 0){
            for (PFObject *object in objects) {
                NSString *tempdrinkability = [object valueForKey:@"Drinkable"];
                if ([tempdrinkability isEqualToString:@"Y"]){
                    yesCount++;
                }else{
                    noCount++;
                }
                NSString *tempUsername = [object valueForKey:@"Username"];
                NSString *tempReview = [object valueForKey:@"ReviewText"];
                if(tempReview != nil && ![tempReview isEqualToString:@""]){
                    [self.userReviewDictionary setObject:tempReview forKey:tempUsername];
                }
            }
            if (yesCount > noCount){
                self.localPeepDrinkable = @"YES";
                self.localPeepProgressBar.progress = (float)yesCount/((float)yesCount+(float)noCount);
                self.localPeepProgressBar.progressTintColor = [UIColor greenColor];
                self.localPeepProgressBar.trackTintColor = [UIColor whiteColor];
            }else{
                self.localPeepDrinkable = @"NO";
                self.localPeepProgressBar.progress = (float)noCount/((float)yesCount+(float)noCount);
                self.localPeepProgressBar.progressTintColor = [UIColor redColor];
                self.localPeepProgressBar.trackTintColor = [UIColor whiteColor];
            }
        }
        else{
            self.localPeepDrinkable = nil;
        }
        NSLog(@"Local Peep Drinkable: %@", self.localPeepDrinkable);
    }
}

- (void)getWaterDrinkabilityForCityState:(NSString *)state :(NSString *)city{
    NSMutableArray *contaminantArray = [[NSMutableArray alloc]init];
    __block int noOfYes = 0;
    __block int noOfNo = 0;
    
    NSString *tempZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    if(tempZip == nil || [tempZip isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    }
    self.currentZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    
    if(self.currentZip == nil || [self.currentZip isEqualToString:@""]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter a valid zip code" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }else{
        PFQuery *query = [PFQuery queryWithClassName:@"ContaminantMaster"];
        [query whereKey:@"State" equalTo:state];
        [query whereKey:@"City" equalTo:city];
        
        NSArray *objects = [query findObjects];
        if(objects.count > 0){
            for (PFObject *object in objects) {
                NSArray* individualZips = [[object valueForKey:@"Zipcodes"] componentsSeparatedByString: @"/"];
                for (NSString *eachZip in individualZips) {
                    if ([self.currentZip isEqualToString:eachZip]) {
                        
                        // Add waterpedia information
                        if (self.waterUtility == nil){
                            self.waterUtility = [object valueForKey:@"waterUtility"];
                            self.dataEnd = [object valueForKey:@"dataEnd"];
                            NSString *tempValue = [NSString stringWithFormat:@"%@ %@", [object valueForKey:@"Parse__exceedingHealthLimit"], @"contaminants"];
                            self.noExceedingHealthLimit = tempValue;
                        }
                        
                        // Add contaminant information
                        [contaminantArray addObject:[object valueForKey:@"healthLimitExceeded"]];
                        if([[object valueForKey:@"healthLimitExceeded"] isEqualToString:@"Y"]){
                            noOfYes++;
                        }else{
                            noOfNo++;
                        }
                    }
                }
            }
            if([contaminantArray count] == 0){
                NSLog(@"Sorry, no data for that ZIP");
            }else{
                float total = (int)[contaminantArray count];
                float yesPercent = noOfYes/total*100;
                if(yesPercent >= 60){
                    self.twidrinkable = @"NO";
                    self.drWaterProgressBar.progress = (100.0-yesPercent)/100.0;
                    self.drWaterProgressBar.progressTintColor = [UIColor redColor];
                    self.localPeepProgressBar.trackTintColor = [UIColor whiteColor];
                }else{
                    self.twidrinkable = @"YES";
                    self.drWaterProgressBar.progress = (100.0-yesPercent)/100.0;
                    self.drWaterProgressBar.progressTintColor = [UIColor greenColor];
                    self.localPeepProgressBar.trackTintColor = [UIColor whiteColor];
                }
                NSLog(@"Drinkable: %@", self.twidrinkable);
                NSLog(@"Waterpedia: %@, %@, %@", self.waterUtility, self.dataEnd, self.noExceedingHealthLimit);
            }
        }
        else{
            PFQuery *query = [PFQuery queryWithClassName:@"ContaminantMaster"];
            [query whereKey:@"State" equalTo:state];
            NSArray *objects = [query findObjects];
            NSLog(@"Successfully retrieved %d entries for state alone.", (int)objects.count);
            if(objects.count > 0){
                for (PFObject *object in objects) {
                    NSArray* individualZips = [[object valueForKey:@"Zipcodes"] componentsSeparatedByString: @"/"];
                    for (NSString *eachZip in individualZips) {
                        if ([self.currentZip isEqualToString:eachZip]) {
                            [contaminantArray addObject:[object valueForKey:@"healthLimitExceeded"]];
                            for (NSString *eachZip in individualZips) {
                                if ([self.currentZip isEqualToString:eachZip]) {
                                    
                                    // Add waterpedia information
                                    if (self.waterUtility == nil){
                                        self.waterUtility = [object valueForKey:@"waterUtility"];
                                        self.dataEnd = [object valueForKey:@"dataEnd"];
                                        NSString *tempValue = [NSString stringWithFormat:@"%@ %@", [object valueForKey:@"Parse__exceedingHealthLimit"], @"contaminants"];
                                        self.noExceedingHealthLimit = tempValue;
                                    }
                                    
                                    // Add contaminant information
                                    [contaminantArray addObject:[object valueForKey:@"healthLimitExceeded"]];
                                    if([[object valueForKey:@"healthLimitExceeded"] isEqualToString:@"Y"]){
                                        noOfYes++;
                                    }else{
                                        noOfNo++;
                                    }
                                }
                            }
                        }
                    }
                }
                if([contaminantArray count] == 0){
                    NSLog(@"Sorry, no data for that ZIP");
                }else{
                    float total = (float)[contaminantArray count];
                    float yesPercent = noOfYes/total*100;
                    if(yesPercent >= 60){
                        self.twidrinkable = @"NO";
                        self.drWaterProgressBar.progress = (100.0-yesPercent)/100.0;
                        self.drWaterProgressBar.progressTintColor = [UIColor redColor];
                        self.localPeepProgressBar.trackTintColor = [UIColor whiteColor];
                    }else{
                        self.twidrinkable = @"YES";
                        self.drWaterProgressBar.progress = (100.0-yesPercent)/100.0;
                        self.drWaterProgressBar.progressTintColor = [UIColor greenColor];
                        self.localPeepProgressBar.trackTintColor = [UIColor whiteColor];
                    }
                    NSLog(@"Drinkable: %@", self.twidrinkable);
                    NSLog(@"Waterpedia: %@, %@, %@", self.waterUtility, self.dataEnd, self.noExceedingHealthLimit);
                }
            }
        }
    }
}


- (void)getUserReview{
    self.userReviewDictionary = [[NSMutableDictionary alloc]init];
    NSString *tempZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    if(tempZip == nil || [tempZip isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    }
    self.currentZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    
    if(self.currentZip == nil || [self.currentZip isEqualToString:@""]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter a valid zip code" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }else{
        PFQuery *query = [PFQuery queryWithClassName:@"UserReview"];
        [query whereKey:@"Zipcode" equalTo:self.currentZip];
        NSArray *objects = [query findObjects];
        
        if(objects.count > 0){
            for (PFObject *object in objects) {
                NSString *tempUsername = [object valueForKey:@"Username"];
                NSString *tempReview = [object valueForKey:@"ReviewText"];
                [self.userReviewDictionary setObject:tempReview forKey:tempUsername];
            }
        }
        NSLog(@"The user reviews are: %@", self.userReviewDictionary);
    }
}


- (void)createUserReview{
    NSString *tempUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    self.currentUser = tempUser;
    
    if(self.currentZip == nil || [self.currentZip isEqualToString:@""]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter a valid zip code" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }else if ([tempUser isEqualToString:@"GUEST"]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Login to post a review" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    else{
        NSString *tempZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
        
        // Add the user review
        PFObject *userReview = [PFObject objectWithClassName:@"UserReview"];
        userReview[@"Username"] = tempUser;
        if(tempZip == nil || [tempZip isEqualToString:@""]){
            [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
        }
        self.currentZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
        userReview[@"Zipcode"] = self.currentZip;
        userReview[@"Drinkable"] = self.inputDrinkable;
        if (self.reviewText != nil){
            userReview[@"ReviewText"] = self.reviewText.text;
        }
        [userReview save];
        
        // Add user points
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"username" equalTo:tempUser];
        
        NSArray *usernamesArray = [query findObjects];
        NSUInteger noOfUsers = [usernamesArray count];
        if (noOfUsers == 1){
            PFObject *userObject = [usernamesArray objectAtIndex:0];
            if ([userObject valueForKey:@"objectId"] != nil){
                NSString *postCount = [userObject valueForKey:@"numberPosted"];
                if (postCount == nil || [postCount isEqualToString:@""]){
                    NSString *postCountString = [NSString stringWithFormat:@"%d", 1];
                    [userObject setObject:postCountString forKey:@"numberPosted"];
                }else{
                    NSString *postCountString = [NSString stringWithFormat:@"%d",postCount.intValue + 1];
                    [userObject setObject:postCountString forKey:@"numberPosted"];
                }
                [userObject save];
            }
        }
        
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your review has been saved!" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
        self.reviewText.text = @"";

        // Update UI
        [self closeUserReviewClicked:nil];
        [self getDrinkabilityByLocalPeeps];
    }
}


- (void) setUserReviewUI{
    int count = 1;
    for(NSString *key in self.userReviewDictionary){
        if (count >= 4){
            break;
        }
        if(count == 1){
            NSString *tempText = [NSString stringWithFormat:@"%@ : %@", key,[self.userReviewDictionary objectForKey:key]];
            self.review1.text = tempText;
        }else if(count == 2){
            NSString *tempText = [NSString stringWithFormat:@"%@ : %@", key,[self.userReviewDictionary objectForKey:key]];
            self.review2.text = tempText;
        }else if(count == 3){
            NSString *tempText = [NSString stringWithFormat:@"%@ : %@", key,[self.userReviewDictionary objectForKey:key]];
            self.review3.text = tempText;
        }
        count++;
    }
}

- (void)clearExistingSubviews{
    self.drinkabilitySubView.hidden = YES;
    self.waterPediaSubView.hidden = YES;
    self.userReviewSubView.hidden = YES;
    
    UIImage *image = [UIImage imageNamed: @"Gray_drop.png"];
    [self.drWaterButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.localPeepButton setBackgroundImage:image forState:UIControlStateNormal];
    self.drinkabilityLabel.text = @"";
    
    self.yearTextField.text = @"";
    self.waterUtilTextField.text = @"";
    self.noOfContaminantsTextField.text = @"";
    
    self.review1.text = @"";
    self.review2.text = @"";
    self.review3.text = @"";
}

- (IBAction)getDrinkabilityClicked:(id)sender {
    self.currentZip = self.location_text.text;
    [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    [self getWaterDrinkabilityForCityState:self.state:self.city];
    [self getDrinkabilityByLocalPeeps];
    [self setDrinkabilityImages];
}

- (IBAction)getWaterPediaClicked:(id)sender {
    NSLog(@"Waterpedia: %@, %@, %@", self.waterUtility, self.dataEnd, self.noExceedingHealthLimit);
    self.yearTextField.text = self.dataEnd;
    self.waterUtilTextField.text = self.waterUtility;
    self.noOfContaminantsTextField.text = self.noExceedingHealthLimit;
    self.drinkabilitySubView.hidden = YES;
    self.waterPediaSubView.hidden = NO;
}

- (IBAction)getUserReviewsClicked:(id)sender {
    [self setUserReviewUI];
    NSString *tempUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    self.currentUser = tempUser;
    self.drinkabilitySubView.hidden = YES;
    self.userReviewSubView.hidden = NO;
    self.displayUserReviewSubview.hidden = NO;
    self.addUserReviewSubview.hidden = YES;
    if ([tempUser isEqualToString:@"GUEST"]){
        self.addUserReviewButton.hidden = YES;
    }else{
        self.addUserReviewButton.hidden = NO;
    }
}

- (IBAction)closeWaterPediaClicked:(id)sender {
    self.waterPediaSubView.hidden = YES;
    self.drinkabilitySubView.hidden = NO;
}

- (IBAction)closeUserReviewClicked:(id)sender {
    self.drinkabilitySubView.hidden = NO;
    self.addUserReviewButton.hidden = YES;
    self.userReviewSubView.hidden = YES;
    self.addUserReviewSubview.hidden = YES;
    self.displayUserReviewSubview.hidden = YES;
}

- (IBAction)userReviewDrinkableClicked:(id)sender {
    self.inputDrinkable = @"Y";
    [self createUserReview];
}

- (IBAction)userReviewNotDrinkableClicked:(id)sender {
    self.inputDrinkable = @"N";
    [self createUserReview];
}

- (IBAction)addUserReviewClicked:(id)sender {
    self.drinkabilitySubView.hidden = YES;
    self.addUserReviewButton.hidden = NO;
    self.userReviewSubView.hidden = NO;
    self.addUserReviewSubview.hidden = NO;
    self.displayUserReviewSubview.hidden = YES;
}


- (IBAction)returnButtonPressed:(id)sender {
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
