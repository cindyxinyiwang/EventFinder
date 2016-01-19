//
//  SortEventViewController.m
//  Event-Finder
//
//  Created by Cindy Wang on 1/18/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "SortEventViewController.h"
#import "SortEventTableViewCell.h"
#import <Parse/Parse.h>

@interface SortEventViewController ()
{
    
}
@property (strong, nonatomic) NSString *className;

@end

@implementation SortEventViewController {
    
    
    NSArray *costs;
}

@synthesize SearchCriteria;
@synthesize SortEventTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self getEvents];
    
    self.SortEventTableView.dataSource = self;
    self.SortEventTableView.delegate = self;
    [self.SortEventTableView reloadData];
     
}


-(void) getEvents {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    if ([self.SearchCriteria isEqualToString:@"Price"]) {
        [query orderByAscending:@"cost"];
        self.events = [query findObjects];

    } else if ([self.SearchCriteria isEqualToString:@"Size"]) {
        [query orderByAscending:@"cost"];
        self.events = [query findObjects];
    } else {
        // order by proximity
        [query orderByAscending:@"cost"];
        self.events = [query findObjects];
    }
    //NSLog(@"Found %lu objects", (unsigned long)[events count]);
    //[self.SortEventTableView reloadData];
}

-(void) getDistanceArray {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"sortEventCell";
    
    SortEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[SortEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    cell.titleLabel.text = event[@"title"];
    cell.costLabel.text = [NSString stringWithFormat:@"Cost: %@", event[@"cost"]];
    
    cell.distanceLabel.text = [self.distance objectAtIndex:indexPath.row];
    return cell;
}



/*
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        self.className = @"Event";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    //PFQuery *query = [PFQuery queryWithClassName:self.className];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    if ([self.SearchCriteria isEqualToString:@"Price"]) {
        [query orderByAscending:@"cost"];
    } else if ([self.SearchCriteria isEqualToString:@"Size"]) {
        [query orderByAscending:@"cost"];
    } else {
        // order by proximity
        [query orderByAscending:@"cost"];
    }
    return query;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"sortEventCell";
    
    SortEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[SortEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.titleLabel.text = [object objectForKey:@"title"];
    cell.costLabel.text = [NSString stringWithFormat:@"Cost: %@", [object objectForKey:@"cost"]];
     
    return cell;
}
*/

@end