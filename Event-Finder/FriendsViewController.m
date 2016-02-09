//
//  FriendsViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/24/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"
#import <Parse/Parse.h>

@interface FriendsViewController () {
    NSArray *users;
    PFUser *currentUser;
}

@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Friends";
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    
    PFQuery *query = [PFUser query];
    // Additional pruning of users to display done here
    self->users = [query findObjects];
    
    self->currentUser = [PFUser currentUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    NSLog(@"Button Clicked");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self->users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendCell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.nameLabel.text = [self->users objectAtIndex:indexPath.row][@"username"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Determine if user is following this person
    [cell.followLabel setTitle:@"Follow" forState:UIControlStateNormal];
    NSArray *following = [self->currentUser objectForKey:@"following"];
    PFUser *userForRow = [self->users objectAtIndex:indexPath.row];
    NSString *id = userForRow.objectId;
    if([following containsObject:id]) {
        cell.followLabel.enabled = NO;
        [cell.followLabel setTitle:@"Following" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end
