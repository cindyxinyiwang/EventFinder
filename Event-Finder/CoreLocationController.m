//
//  CoreLocationController.m
//  Event-Finder
//
//  Created by Cindy Wang on 1/19/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "CoreLocationController.h"
#import "CoreLocation/CoreLocation.h"

@implementation CoreLocationController

- (id)init {
    self = [super init];
    if(self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    //#ifdef __IPHONE_8_0
      //  if(IS_OS_8_OR_LATER) {
            [self.locationManager requestWhenInUseAuthorization];
        //}
    //#endif
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.delegate update:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.delegate locationError:error];
}

@end

