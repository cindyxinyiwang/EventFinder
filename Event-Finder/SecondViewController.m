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

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.MyEventTableView.dataSource = self;
    self.MyEventTableView.delegate = self;
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
    NSLog(@"Creating cell number: %ld", (long)indexPath.row);
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
        //cell.costLabel.text = event[@"Cost"];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
