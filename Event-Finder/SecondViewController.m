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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.MyEventTableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.MyEventTableView reloadData];
    [refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.MyEventTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
        [eventQuery whereKey:@"createdBy" equalTo:[PFUser currentUser]];
        return [eventQuery countObjects];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Going"];
        [query whereKey:@"guest" equalTo:[PFUser currentUser]];
        return [query countObjects];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Hosting";
    } else {
        return @"Going To";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"myEventCell";
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section == 0) {
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
        [eventQuery whereKey:@"createdBy" equalTo:[PFUser currentUser]];
        [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
            PFObject *event = [events objectAtIndex:indexPath.row];
            cell.titleLabel.text = event[@"title"];
            cell.addressLabel.text = event[@"address"];
            cell.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", event[@"cost"]];
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Going"];
        [query orderByDescending:@"startTime"];
        [query whereKey:@"guest" equalTo:[PFUser currentUser]];
        [query includeKey:@"event"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable goingEvents, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error: %@", error);
            } else {
                PFObject *goingEvent = [goingEvents objectAtIndex:indexPath.row];
                PFObject *event = goingEvent[@"event"];
                cell.titleLabel.text = event[@"title"];
                cell.addressLabel.text = event[@"address"];
                cell.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", event[@"cost"]];
            }
         }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"viewEventSegue"]) {
        NSIndexPath *indexPath = [self.MyEventTableView indexPathForSelectedRow];
        NSLog(@"Destination: %@", segue.destinationViewController);
        EventViewController *destinationViewController = segue.destinationViewController;
        
        if(indexPath.section==0) {
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
                [destinationViewController viewDidLoad];
            }];
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Going"];
            [query orderByDescending:@"startTime"];
            [query whereKey:@"guest" equalTo:[PFUser currentUser]];
            [query includeKey:@"event"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable goingEvents, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"Error: %@", error);
                } else {
                    PFObject *goingEvent = [goingEvents objectAtIndex:indexPath.row];
                    PFObject *event = goingEvent[@"event"];
                    destinationViewController.eventTitle = event[@"title"];
                    destinationViewController.address = event[@"address"];
                    destinationViewController.cost = event[@"cost"];
                    destinationViewController.startTime = event[@"endTime"];
                    destinationViewController.endTime = event[@"startTime"];
                    destinationViewController.desc = event[@"description"];
                    destinationViewController.eventId = event.objectId;
                    [destinationViewController viewDidLoad];
                }
            }];
        }
    }
}

@end
