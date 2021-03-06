//
//  FirstViewController.h
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "CoreLocationController.h"

@interface FirstViewController : UIViewController <MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CoreLocationControllerDelegate >

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIPickerView *sortPicker;
@property (nonatomic, strong) CoreLocationController *locationManager;
//@property (nonatomic, strong) CLLocationManager *locationManager;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@end

