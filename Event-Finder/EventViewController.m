//
//  EventViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/17/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "EventViewController.h"
#import <Parse/Parse.h>

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *goingSwitch;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up the main labels
    self.titleLabel.text = self.eventTitle;
    self.descriptionLabel.text = self.desc;
    self.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", self.cost];
    self.addressLabel.text = self.address;
    
    // Set up the time information
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm";
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@", [dateFormatter stringFromDate:self.startTime]];
    self.startTimeLabel.text = [NSString stringWithFormat:@"Starts: %@", [timeFormatter stringFromDate:self.startTime]];
    self.endTimeLabel.text = [NSString stringWithFormat:@"Ends: %@", [timeFormatter stringFromDate:self.endTime]];
    
    // Set the switch to its proper value
    PFQuery *query = [PFQuery queryWithClassName:@"Going"];
    [query whereKey:@"guest" equalTo:[PFUser currentUser]];
    
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery getObjectInBackgroundWithId:self.eventId block:^(PFObject * _Nullable event, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Could not find an event");
        } else {
            [query whereKey:@"event" equalTo:event];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"Error determining if user is going: %@", error);
                } else {
                    if([objects count]) {
                        NSLog(@"User is already going");
                        [self.goingSwitch setOn:YES animated:YES];
                    } else {
                        NSLog(@"User is not going");
                        [self.goingSwitch setOn:NO animated:YES];
                    }
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goingSwitched:(id)sender {
    NSLog(@"Event id: %@", self.eventId);

    if([self.goingSwitch isOn]) {
        NSLog(@"Switch turned on");
        
        // Add that the current user is going to this event
        PFObject *goingToEvent = [PFObject objectWithClassName:@"Going"];
        [goingToEvent setObject:[PFUser currentUser] forKey:@"guest"];
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        PFObject *event = [query getObjectWithId:self.eventId];
        [goingToEvent setObject:event forKey:@"event"];
        [goingToEvent saveInBackground];
    } else {
        NSLog(@"Switch turned off");

        // Delete that the current user is going
        PFQuery *query = [PFQuery queryWithClassName:@"Going"];
        [query whereKey:@"guest" equalTo:[PFUser currentUser]];
        
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
        [eventQuery getObjectInBackgroundWithId:self.eventId block:^(PFObject * _Nullable event, NSError * _Nullable error) {
            [query whereKey:@"event" equalTo:event];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"Error setting this user to not go to the event: %@", error);
                } else {
                    for(PFObject *object in objects) {
                        [object deleteInBackground];
                    }
                }
            }];
        }];
    }
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
