//
//  FeedTableViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/17/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FeedTableViewController.h"
#import <Parse/Parse.h>

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PFQuery *query = [PFQuery queryWithClassName:@"Going"];
    return [query countObjects];
}

-(instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        self.parseClassName = @"Going";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

-(PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"Going"];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"feedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    PFQuery *query = [PFQuery queryWithClassName:@"Going"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"guest"];
    [query includeKey:@"event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable goingEvents, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error: %@", error);
        } else {
            PFObject *goingEvent = [goingEvents objectAtIndex:indexPath.row];
            PFObject *event = goingEvent[@"event"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ is going to %@", [[goingEvent objectForKey:@"guest"] objectForKey:@"username"], event[@"title"]];
        }
    }];
    
    return cell;
}

@end
