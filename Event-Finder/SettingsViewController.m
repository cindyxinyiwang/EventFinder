//
//  SettingsViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/18/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logOutSegue" sender:self];
}

@end
