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
@property (weak, nonatomic) IBOutlet UILabel *Title;

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
    [self.locationManger requestWhenInUseAuthorization];
    [self.locationManger startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self loadEventsOnMap];
    //NSString *location = @"450 Serra Mall, Stanford, CA 94305";
    //[self loadAdrressOnMap:location];
}

- (void)loadEventsOnMap {
    //NSString *location = @"450 Serra Mall, Stanford, CA 94305";
    PFQuery *eventsQuery = [PFQuery queryWithClassName:@"Event"];
    /*
    [eventsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            // find succeeded.
            NSLog(@"Succeesfully found %lu events", objects.count);
            for (PFObject *object in objects) {
                [self loadAdrressOnMap:object[@"address"]];
            }
        } else {
            
        }
    }];
     */
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

@end
