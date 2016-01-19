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
    //NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
