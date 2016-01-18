//
//  EventViewController.h
//  Event-Finder
//
//  Created by David Mattia on 1/17/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *eventId;

@end
