//
//  FirstViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>


@interface FirstViewController ()
{
    NSArray *_pickerData;
}
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextField *sortByTextField;
@end

@implementation FirstViewController

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManger = [[CLLocationManager alloc] init];
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManger requestWhenInUseAuthorization];
    }
    #endif
    [self.locationManger startUpdatingLocation];
    
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
    NSLog(@"decoding %@", addr);
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
                         NSLog(@"Added location.");
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
     NSLog(@"inside didUpdateLocation");
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
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
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
        
    }
}

@end
