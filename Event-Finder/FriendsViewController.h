//
//  FriendsViewController.h
//  Event-Finder
//
//  Created by David Mattia on 1/24/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *friendsTableView;

@end
