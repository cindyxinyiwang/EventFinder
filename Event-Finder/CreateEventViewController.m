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

- (IBAction)doneClicked:(id)sender {
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"title"] = self.eventTitle.text;
    event[@"public"] = @YES;
    event[@"startTime"] = self.startTime.date;
    event[@"endTime"] = self.endTime.date;
    event[@"description"] = self.descriptionText.text;
    event[@"address"] = self.addressText.text;
    event[@"cost"] = [NSNumber numberWithFloat:[self.costText.text floatValue]];
    [event setObject:[PFUser currentUser] forKey:@"createdBy"];
    [event saveInBackground];
    
    NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
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
