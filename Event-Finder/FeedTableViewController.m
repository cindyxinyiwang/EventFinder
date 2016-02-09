//
//  FeedTableViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/17/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FeedTableViewController.h"
#import <Parse/Parse.h>

@interface FeedTableViewController () {
    NSArray *queryEventResults;
}
@property (strong, nonatomic) IBOutlet UITableView *eventTableView;

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    PFQuery *query = [PFQuery queryWithClassName:@"Going"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"guest"];
    [query includeKey:@"event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable goingEvents, NSError * _Nullable error) {
        queryEventResults = goingEvents;
        [self.eventTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(queryEventResults != nil) {
        return [queryEventResults count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"feedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    PFObject *goingEvent = [queryEventResults objectAtIndex:indexPath.row];
    PFObject *event = goingEvent[@"event"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ is going to %@", [[goingEvent objectForKey:@"guest"] objectForKey:@"username"], event[@"title"]];
    
    return cell;
}

@end
