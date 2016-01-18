//
//  EventViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/17/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "EventViewController.h"

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
    // Do any additional setup after loading the view.
    NSLog(@"Value of eventTitle in viewDidLoad: %@", self.eventTitle);
    self.titleLabel.text = self.eventTitle;
    self.descriptionLabel.text = self.desc;
    self.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", self.cost];
    self.addressLabel.text = self.address;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm";
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@", [dateFormatter stringFromDate:self.startTime]];
    self.startTimeLabel.text = [NSString stringWithFormat:@"Starts: %@", [timeFormatter stringFromDate:self.startTime]];
    self.endTimeLabel.text = [NSString stringWithFormat:@"Ends: %@", [timeFormatter stringFromDate:self.endTime]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
