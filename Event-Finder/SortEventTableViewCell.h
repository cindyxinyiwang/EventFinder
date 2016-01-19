//
//  SortEventTableViewCell.h
//  Event-Finder
//
//  Created by Cindy Wang on 1/18/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortEventTableViewCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@end
