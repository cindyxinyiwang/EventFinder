//
//  FirstViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FirstViewController.h"
#import "SortEventViewController.h"
#import "EventViewController.h"
#include "EventObject.h"
#import "MapViewAnnotation.h"

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
@property (strong, nonatomic) CLLocation *curLocation;
//@property (strong, nonatomic) NSMutableDictionary *annotToEvent;
@property (strong, nonatomic) NSString *annoEventTitle;

@property (strong, nonatomic) MKAnnotationView *curAnnotation;

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
    NSLog(@"Start updating location: %1f", [self.curLocation coordinate].latitude);
}

- (void)locationError:(NSError *)error {
    //self.lblLatitude.text = [error description];
    //self.lblLongitude.text = nil;
    NSLog(@"Location Error: %@", [error description]);
}

- (void)loadEventsOnMap {
    //NSString *location = @"450 Serra Mall, Stanford, CA 94305";
    PFQuery *eventsQuery = [PFQuery queryWithClassName:@"Event"];
    NSArray *eventArray = [eventsQuery findObjects];
    for(PFObject *event in eventArray) {
        PFGeoPoint *point = event[@"location"];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:event[@"title"] AndCoordinate:location];
        [self.mapView addAnnotation:annotation];
    }
}

- (BOOL) isAddress: (NSString *) addr withinDistance: (int) dist
{
    NSString *distToCurLoc = [self getOneDistance:addr];
    if ([distToCurLoc integerValue] < dist){
        return FALSE;
    }
    return TRUE;
}

- (void) loadAdrressOnMap: (PFObject *) event
{
    //NSLog(@"decoding %@", addr);
    NSString* addr = event[@"address"];
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
                         
                         MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:event[@"title"] AndCoordinate:placemark.location.coordinate];
                         [self.mapView addAnnotation:annotation];
                         
                         // update annotation map
                         //self.annoEventId = event[@"objectId"];
                     }
                 }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MapViewAnnotation *selectedAnnotation = view.annotation; // This will give the annotation.
    self.annoEventTitle = selectedAnnotation.title;
}

- (void)mapView: (MKMapView *)mapView annotationView:(nonnull MKAnnotationView *)view calloutAccessoryControlTapped:(nonnull UIControl *)control {
    
    [self performSegueWithIdentifier:@"MapToEvent" sender:view];
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
        
        //[query orderByAscending:@"cost"];
        NSArray *objects = [query findObjects];
        NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
        for (PFObject *obj in objects) {
            EventObject *event = [[EventObject alloc] init];
            event.title = obj[@"title"];
            event.address = obj[@"address"]; 
            event.cost = obj[@"cost"];
            event.distance = [self getOneDistance:event.address];
            event.eventId = obj[@"objectId"];
            event.startTime = obj[@"startTime"];
            event.endTime = obj[@"endTime"];
            event.desc = obj[@"description"];
            
            // find number of people going
            PFQuery *goingQuery = [PFQuery queryWithClassName:@"Going"];
            [goingQuery whereKey:@"event" equalTo:obj];
            event.size = [NSString stringWithFormat:@"%ld", (long)[goingQuery countObjects]];

            [eventsArray addObject:event];
        }
        
        sortEventController.eventObjects = eventsArray;

        sortEventController.SearchCriteria = sortCriteria;
    } else if ([[segue identifier] isEqualToString:@"addFriendsSegue"]) {
        // Do Nothing
    } else {
        EventViewController *eventView = segue.destinationViewController;
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"title" equalTo:self.annoEventTitle];
        NSArray *objects = [query findObjects];
        PFObject *cur_Event = objects[0];
        eventView.title = cur_Event[@"title"];
        eventView.address = cur_Event[@"address"];
        eventView.cost = cur_Event[@"cost"];
        eventView.eventId = cur_Event[@"objectId"];
        eventView.startTime = cur_Event[@"startTime"];
        eventView.endTime = cur_Event[@"endTime"];
        eventView.desc = cur_Event[@"description"];
    }
}

-(NSString*) getOneDistance: (NSString*) addr {
    CLLocationCoordinate2D addrLoc = [self getLocationFromAddressString:addr];
    CLLocation *addrCLLoc = [[CLLocation alloc] initWithLatitude:addrLoc.latitude longitude:addrLoc.longitude];
    NSLog(@"Current location %f", [self.curLocation coordinate].latitude);
    NSLog(@"Dest location %f", addrLoc.latitude);
    // !!might curLocation not set
    CLLocationDistance meters = [addrCLLoc distanceFromLocation:self.curLocation];
    return [NSString stringWithFormat:@"%.1f Miles", meters/1609.344];
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        //NSLog(@"Geting LL %@", addressStr);
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
    //NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    //NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}



@end
