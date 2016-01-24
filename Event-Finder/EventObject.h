//
//  EventObject.h
//  Event-Finder
//
//  Created by Cindy Wang on 1/19/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

@interface EventObject : NSObject

@property NSString *title;
@property NSString *address;
@property NSString *cost;
@property NSString *distance;
@property NSString *eventId;
@property NSString *size;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *desc;

@end

