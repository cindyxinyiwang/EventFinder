//
//  FeedViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "FeedTableViewCell.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    [self.feedTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PFQuery *feedQuery = [PFQuery queryWithClassName:@"Going"];
    NSLog(@"Feed table count: %ld", (long)[feedQuery countObjects]);
    return [feedQuery countObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"feedCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Set the cells username and eventName properties
    PFQuery *feedQuery = [PFQuery queryWithClassName:@"Going"];
    [feedQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        __block NSString *username, *eventTitle;
        PFObject *event = [events objectAtIndex:indexPath.row];
        PFObject *user = event[@"guest"];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *userObject, NSError *error) {
            if(error) {
                NSLog(@"Could not find user for event");
            } else {
                username = userObject[@"username"];
                NSLog(@"Username: %@", username);
            }
        }];
        eventTitle = @"event";
        cell.feedLabel.text = [NSString stringWithFormat:@"%@ is going to %@", username, eventTitle];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
