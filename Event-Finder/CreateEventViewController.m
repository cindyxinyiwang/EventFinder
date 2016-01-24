//
//  CreateEventViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "CreateEventViewController.h"
#import <Parse/Parse.h>

@interface CreateEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *costText;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonClicked:(id)sender {
<<<<<<< HEAD
    if(self.eventTitle.text.length > 0 &&
       self.addressText.text.length > 0 &&
       self.costText.text.length > 0) {
        NSLog(@"Creating event %@", self.eventTitle.text);
        PFObject *event = [PFObject objectWithClassName:@"Event"];
        event[@"title"] = self.eventTitle.text;
        event[@"public"] = @YES;
        event[@"startTime"] = self.startTime.date;
        event[@"endTime"] = self.endTime.date;
        event[@"description"] = self.descriptionText.text;
        event[@"address"] = self.addressText.text;
        event[@"cost"] = [NSNumber numberWithFloat:[self.costText.text floatValue]];
        [event setObject:[PFUser currentUser] forKey:@"createdBy"];
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(!succeeded) {
                NSLog(@"Could not save event. error: %@", error);
            } else {
                NSLog(@"Finished saving object");
            }
        }];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Form Error"
                                                        message:@"The title, address, and cost fields are required."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
=======
    NSLog(@"Creating event %@", self.eventTitle.text);
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"title"] = self.eventTitle.text;
    event[@"public"] = @YES;
    event[@"startTime"] = self.startTime.date;
    event[@"endTime"] = self.endTime.date;
    event[@"description"] = self.descriptionText.text;
    event[@"address"] = self.addressText.text;
    
    CLLocationCoordinate2D coord = [self getLocationFromAddressString:self.addressText.text];
    //event[@"location"] = PFGeoPoint();
    
    
    event[@"cost"] = [NSNumber numberWithFloat:[self.costText.text floatValue]];
    [event setObject:[PFUser currentUser] forKey:@"createdBy"];
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded) {
            NSLog(@"Could not save event. error: %@", error);
        } else {
            NSLog(@"Finished saving object");
        }
    }];
    //NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
>>>>>>> bd0df9112eb3e8fbcfea835f1a467311edebc708
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
