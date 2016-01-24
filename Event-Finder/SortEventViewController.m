//
//  SortEventViewController.m
//  Event-Finder
//
//  Created by Cindy Wang on 1/18/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "SortEventViewController.h"
#import "SortEventTableViewCell.h"
#import "EventViewController.h"
#import "EventObject.h"
#import <Parse/Parse.h>

@interface SortEventViewController ()
{
    NSArray *_pickerData;
}
@property (strong, nonatomic) NSString *className;

@property (weak, nonatomic) IBOutlet UITextField *sortByTextField;

@end

@implementation SortEventViewController {
    
    
    NSArray *costs;
}

@synthesize SearchCriteria;
@synthesize SortEventTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.eventObjects = [self getEvents];
    
    self.SortEventTableView.dataSource = self;
    self.SortEventTableView.delegate = self;
    
    // Initialize picker data
    _pickerData = @[@"Proximity", @"Price", @"Size"];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.sortByTextField.inputView = picker;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.SortEventTableView addSubview:refreshControl];
     
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.SortEventTableView reloadData];
    [refreshControl endRefreshing];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.SortEventTableView reloadData];
}

// picker view setup
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.sortByTextField.text = _pickerData[row];
    [self.sortByTextField resignFirstResponder];
    
    self.SearchCriteria = _pickerData[row];
    self.eventObjects = [self getEvents];
    
    [self.SortEventTableView reloadData];
    [self.tableView reloadData];
}

-(NSArray*) getEvents {
    NSArray *sortedArray;
    
    if ([self.SearchCriteria isEqualToString:@"Price"]) {
        sortedArray = [self.eventObjects sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *first = [(EventObject*)obj1 cost];
            NSString *second = [(EventObject*)obj2 cost];
            return [first floatValue] >=[second floatValue];
        }];
        
    } else if ([self.SearchCriteria isEqualToString:@"Size"]) {
        sortedArray = [self.eventObjects sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *first = [(EventObject*)obj1 size];
            NSString *second = [(EventObject*)obj2 size];
            return [first floatValue] >=[second floatValue];
        }];
        
    } else {
        // order by proximity
        sortedArray = [self.eventObjects sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *first = [(EventObject*)obj1 distance];
            NSString *second = [(EventObject*)obj2 distance];
            return [first floatValue] >=[second floatValue];
        }];
        
    }    
    return sortedArray;
    //NSLog(@"Found %lu objects", (unsigned long)[events count]);
    //[self.SortEventTableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    //return [self.events count];
    return [self.eventObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"sortEventCell";
    
    SortEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[SortEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    /*
    PFObject *event = [self.event objectAtIndex:indexPath.row];
    cell.titleLabel.text = event[@"title"];
    cell.costLabel.text = [NSString stringWithFormat:@"Cost: %@", event[@"cost"]];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %@",[self.distance objectAtIndex:indexPath.row]];
     */
    EventObject *curEvent = [self.eventObjects objectAtIndex:indexPath.row];
    cell.titleLabel.text = curEvent.title;
    cell.costLabel.text = [NSString stringWithFormat:@"Cost: %@", curEvent.cost];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %@",curEvent.distance];
    cell.sizeLabel.text = [NSString stringWithFormat:@"Size: %@ people", curEvent.size];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];*/
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sortToEvent"]) {
        EventViewController *eventView = segue.destinationViewController;
        EventObject *cur_event = self.eventObjects[[self.tableView indexPathForSelectedRow].row];
        eventView.eventTitle = cur_event.title;
        eventView.eventId = cur_event.eventId;
        eventView.startTime = cur_event.startTime;
        eventView.endTime = cur_event.endTime;
        eventView.desc = cur_event.desc;
        eventView.address = cur_event.address;
        eventView.cost = cur_event.cost;
        /*
        
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"objectId" equalTo:cur_event.eventId];
        NSArray *results = [query findObjects];
        if (results.count > 0) {
            PFObject *eventObj = results[0];
            eventView.eventTitle = cur_event.title;
            eventView.cost = eventObj[@"cost"];
            eventView.startTime = eventObj[@"startTime"];
            eventView.endTime = eventObj[@"endTime"];
            eventView.desc = eventObj[@"description"];
            eventView.address = eventObj[@"address"];
            eventView.eventId = cur_event.eventId;
        }*/
        //PFObject *eventObj = [PFObject objectWithoutDataWithClassName:@"Event" objectId:cur_event.eventId];
        
        
    }
        
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