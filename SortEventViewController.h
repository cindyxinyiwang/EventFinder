//
//  SortEventViewController.h
//  Event-Finder
//
//  Created by Cindy Wang on 1/18/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface SortEventViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *SearchCriteria;
@property (nonatomic, strong) NSArray *eventObjects;
@property (weak, nonatomic) IBOutlet UITableView *SortEventTableView;

@end