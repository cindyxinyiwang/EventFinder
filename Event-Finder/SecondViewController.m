//
//  SecondViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "SecondViewController.h"
#import <Parse/Parse.h>
#import "EventTableViewCell.h"
#import "EventViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.MyEventTableView.dataSource = self;
    self.MyEventTableView.delegate = self;
    [self.MyEventTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    return [eventQuery countObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"myEventCell";
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        PFObject *event = [events objectAtIndex:indexPath.row];
        cell.titleLabel.text = event[@"title"];
        cell.addressLabel.text = event[@"address"];
        cell.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", event[@"cost"]];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"viewEventSegue"]) {
        NSIndexPath *indexPath = [self.MyEventTableView indexPathForSelectedRow];
        EventViewController *destinationViewController = segue.destinationViewController;
        
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
        [eventQuery whereKey:@"createdBy" equalTo:[PFUser currentUser]];
        [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
            PFObject *event = [events objectAtIndex:indexPath.row];
            destinationViewController.eventTitle = event[@"title"];
            destinationViewController.address = event[@"address"];
            destinationViewController.cost = event[@"cost"];
            destinationViewController.startTime = event[@"endTime"];
            destinationViewController.endTime = event[@"startTime"];
            destinationViewController.desc = event[@"description"];
            destinationViewController.eventId = event.objectId;
            NSLog(@"Sending eventId: %@", event.objectId);
            [destinationViewController viewDidLoad];
        }];
    }
}

@end
