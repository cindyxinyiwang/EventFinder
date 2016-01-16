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

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"endTime"] = @"8:00pm";
    event[@"startTime"] = @"6:00pm";
    [event saveInBackground];
    */
    self.Title.text = @"Hello";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
