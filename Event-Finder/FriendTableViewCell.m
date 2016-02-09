//
//  FriendTableViewCell.m
//  Event-Finder
//
//  Created by David Mattia on 1/24/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <Parse/Parse.h>

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followButtonClicked:(id)sender {
    NSLog(@"Button clicked for: %@", self.nameLabel.text);
    // Add clicked on user to current user's following list if not already present
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.nameLabel.text];
    NSArray *users = [query findObjects];
    
    if([users count] == 1) {
        PFUser *userClicked = [users objectAtIndex:0];
        NSMutableArray *following = [currentUser objectForKey:@"following"];
        if(following == nil) {
            following = [NSMutableArray array];
        }
        if([following indexOfObject:userClicked.objectId] == NSNotFound) {
            [following addObject:userClicked.objectId];
            currentUser[@"following"] = following;
            [currentUser saveInBackground];
        }
    }
    self.followLabel.enabled = NO;
    [self.followLabel setTitle:@"Following" forState:UIControlStateNormal];
}

@end
