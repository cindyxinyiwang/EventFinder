//
//  CreateEventViewController.h
//  Event-Finder
//
//  Created by David Mattia on 1/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *startTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTime;

@end
