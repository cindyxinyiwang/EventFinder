//
//  SecondViewController.h
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MyEventTableView;

@end

