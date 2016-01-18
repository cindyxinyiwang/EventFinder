//
//  FeedTableViewCell.h
//  Event-Finder
//
//  Created by David Mattia on 1/17/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *feedLabel;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *eventName;

@end
