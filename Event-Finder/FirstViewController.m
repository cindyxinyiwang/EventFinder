//
//  FirstViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FirstViewController.h"
#import "SortEventViewController.h"

#import <Parse/Parse.h>


@interface FirstViewController ()
{
    NSArray *_pickerData;
}
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextField *sortByTextField;
/*
@property (nonatomic) float cur_latitude;
@property (nonatomic) float cur_longitude;
 */
@property (weak, nonatomic) CLLocation *curLocation;


@end

@implementation FirstViewController

@synthesize mapView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    self.locationManager = [[CLLocationManager alloc] init];
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    #endif
    [self.locationManager startUpdatingLocation];
    */
    
    
    self.locationManager = [[CoreLocationController alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self loadEventsOnMap];
    
    // Initialize picker data
    _pickerData = @[@"Proximity", @"Price", @"Size"];
    self.sortPicker.dataSource = self;
    self.sortPicker.delegate = self;
    
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.sortByTextField.inputView = picker;

}

// location controller delegate methods
- (void)update:(CLLocation *)location {
    //self.lblLatitude.text= [NSString stringWithFormat:@"Latitude: %f", [location coordinate].latitude];
    //self.lblLongitude.text = [NSString stringWithFormat:@"Longitude: %f", [location coordinate].longitude];
    //self.cur_latitude = [location coordinate].latitude;
    //self.cur_longitude = [location coordinate].longitude;
    self.curLocation = location;
}

- (void)locationError:(NSError *)error {
    //self.lblLatitude.text = [error description];
    //self.lblLongitude.text = nil;
    NSLog(@"Location Error: %@", [error description]);
}

- (void)loadEventsOnMap {
    //NSString *location = @"450 Serra Mall, Stanford, CA 94305";
    PFQuery *eventsQuery = [PFQuery queryWithClassName:@"Event"];
    NSArray *addrArray = [eventsQuery findObjects];
    for (PFObject *addr in addrArray) {
        [self loadAdrressOnMap:addr[@"address"]];
    }
}

- (void) loadAdrressOnMap: (NSString *) addr
{
    //NSLog(@"decoding %@", addr);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addr
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:placemark];
                     }
                 }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    NSLog(@"inside didUpdateLocation");
}

-(void)zoomInOnLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

// picker view setup
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.sortByTextField.text = _pickerData[row];
    [self.sortByTextField resignFirstResponder];
    
    [self performSegueWithIdentifier:@"sortBySegue" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sortBySegue"])
    {
        NSString *sortCriteria = self.sortByTextField.text;
        
        SortEventViewController *sortEventController = segue.destinationViewController;
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query orderByAscending:@"cost"];
        sortEventController.events = [query findObjects];
        
        // get distance
        NSMutableArray *dist = [[NSMutableArray alloc] init];
        for (PFObject *obj in sortEventController.events) {
            NSString *addr = obj[@"address"];
            CLLocationCoordinate2D addrLoc = [self getLocationFromAddressString:addr];
            CLLocation *addrCLLoc = [[CLLocation alloc] initWithLatitude:addrLoc.latitude longitude:addrLoc.longitude];
            // !!might curLocation not set
            CLLocationDistance meters = [addrCLLoc distanceFromLocation:self.curLocation];
            [dist addObject:[NSString stringWithFormat:@"%1f", meters]];
        }
        
        sortEventController.distance = dist;
        sortEventController.SearchCriteria = sortCriteria;
    }
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}



@end
