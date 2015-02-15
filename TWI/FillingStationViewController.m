//
//  FillingStationViewController.m
//  TWI
//
//  Created by Jamini Sampathkumar on 12/26/14.
//  Copyright (c) 2014 J. All rights reserved.
//

#import "FillingStationViewController.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface FillingStationViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) NSString *currentZip;

@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;

@property (strong, nonatomic) NSMutableDictionary *nameAbbreviations;

@property (weak, nonatomic) IBOutlet UITextField *location_text;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *fillingStationAddress;
@property (strong, nonatomic) IBOutlet UITextField *fillingStationFloor;
@property (strong, nonatomic) IBOutlet UIView *addFillingStationSubView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation FillingStationViewController {
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
    
    [self initializeDictionary];
    
    // Set login & settings button
    NSString *tempUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    if (tempUser == nil || [tempUser isEqualToString:@""] || [tempUser isEqualToString:@"GUEST"]){
        self.loginButton.hidden = NO;
        self.settingsButton.hidden = YES;
    }else{
        self.loginButton.hidden = YES;
        self.settingsButton.hidden = NO;
    }
    
    // self.location_text.text = @"10022";
    // [self createFillingStation:@"62.7467365" :@"-50.09876"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    /*if (curr_location.longitude == 0 && curr_location.latitude == 0){
     curr_location = currentLocation.coordinate;
     [self setUpMap];
     }*/
    if (self.currentZip == nil || [self.currentZip isEqualToString:@""]){
        self.currentZip = self.location_text.text;
        [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    }
    // NSLog(@"Location text at location manager %@", self.location_text.text);
}

- (void)setUpMap {
    //MKCoordinateSpan span = {latitudeDelta: 1, longitudeDelta: 1};
    //MKCoordinateRegion region = {curr_location, span};
    //[self.mapView setRegion:region];
    
    float spanX = 0.0125;
    float spanY = 0.0125;
    curr_location = locationManager.location;
    NSLog(@"Initializing the location map first time: %@", curr_location.description); //A quick NSLog to show us that location data is being received.
    MKCoordinateRegion region;
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    
    
    /*
     CLLocationCoordinate2D timesSquareCoordinates = CLLocationCoordinate2DMake(40.758895, -73.985131);
     Annotation *timesSquareAnnotation = [[Annotation alloc] initWithTitle:@"Times Square" Location:timesSquareCoordinates];
     [self.mapView addAnnotation:timesSquareAnnotation];
     
     CLLocationCoordinate2D radioCityCoordinates = CLLocationCoordinate2DMake(40.760118, -73.979786);
     Annotation *radioCityAnnotation = [[Annotation alloc] initWithTitle:@"Radio City" Location:radioCityCoordinates];
     [self.mapView addAnnotation:radioCityAnnotation];
     */
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

- (IBAction)showFillingStations:(id)sender {

    // clear previous map annotations
    [self removeAllAnnotations];
    
    // get location details from zip
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.location_text.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            
            // set zip
            self.currentZip = [NSString stringWithFormat:@"%@", self.location_text.text];
            [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
            // set city
            self.city = [NSString stringWithFormat:@"%@", placemark.locality];
            // set state
            NSString *tempState = [self.nameAbbreviations objectForKey:placemark.administrativeArea];
            self.state = tempState;
            
            // center region on latitude and longitude of this zipcode
            MKCoordinateRegion region;
            float spanX = 0.0125;
            float spanY = 0.0125;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            // set map view to be centered around new latitude and longitude
            [self.mapView setRegion:region animated:YES];
            
            // Get filling stations and add them to map
            NSMutableDictionary *fillingStationList = [self getFillingStations];
            
            for(id key in fillingStationList) {
                NSLog(@"key=%@ value=%@", key, [fillingStationList objectForKey:key]);
                
                float lat = [key floatValue];
                float lon = [[fillingStationList objectForKey:key] floatValue];
                
                CLLocationCoordinate2D currCoordinates = CLLocationCoordinate2DMake(lat, lon);
                Annotation *currAnnotation = [[Annotation alloc] initWithTitle:@"Filling Station" Location:currCoordinates];
                [self.mapView addAnnotation:currAnnotation];
            }
        }
    }];
    
}

-(void)removeAllAnnotations
{
    //Get the current user location annotation.
    id userAnnotation=self.mapView.userLocation;
    
    //Remove all added annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [self.mapView addAnnotation:userAnnotation];
}

- (void)createFillingStation: (NSString *) inputLatitude :(NSString *)inputLongitude{
    NSString *tempUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    
    if ([tempUser isEqualToString:@"GUEST"]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Login to add filling station" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alertsuccess show];
    }
    else{
        NSString *tempZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
        if(tempZip == nil || [tempZip isEqualToString:@""]){
            [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
        }
        PFObject *fillingStation = [PFObject objectWithClassName:@"FillingStation"];
        fillingStation[@"Username"] = tempUser;
        fillingStation[@"latitude"] = inputLatitude;
        fillingStation[@"longitude"] = inputLongitude;
        fillingStation[@"Zipcode"] = tempZip;
        
        // Uncomment after adding comments and a text view called comment_box
        //fillingStation[@"Comment"] = self.comment_box.text;
        
        [fillingStation save];
        
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
        NSLog(@"Filling station added");
    }
}


- (NSMutableDictionary *)getFillingStations {
    NSMutableDictionary *fillingStationList = [[NSMutableDictionary alloc]init];
    
    NSString *tempZip = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentZip"];
    if(tempZip == nil || [tempZip isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject:self.location_text.text forKey:@"currentZip"];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"FillingStation"];
    [query whereKey:@"Zipcode" equalTo:tempZip];
    NSArray *objects = [query findObjects];
    
    if(objects.count > 0){
        for (PFObject *object in objects) {
            //NSString *tempUsername = [object valueForKey:@"Username"];
            NSString *tempLatitude = [object valueForKey:@"latitude"];
            NSString *tempLongitude = [object valueForKey:@"longitude"];
            NSString *tempComment = [object valueForKey:@"Comment"];
            [fillingStationList setObject:tempLongitude forKey:tempLatitude];
        }
    }

    return fillingStationList;
}

- (IBAction)addFillingStationSubView:(id)sender {
    self.addFillingStationSubView.hidden = NO;
}

- (IBAction)addFillingStation:(id)sender {
    if (curr_location != nil){
        
        NSString *lat = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
        NSString *lon = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
        [self createFillingStation:lat :lon];
        
        [self showFillingStations:nil];
    }
}
- (IBAction)returnButtonPressed:(id)sender {
    [self showFillingStations:sender];
}

- (IBAction)returnButtonPressedFillingStation:(id)sender {
}

- (NSMutableArray *) getTopCities {
    NSMutableArray *topCities = [[NSMutableArray alloc] init];
    
    return topCities;
}

- (IBAction)closeAddFillingStation:(id)sender {
    self.addFillingStationSubView.hidden = YES;
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
