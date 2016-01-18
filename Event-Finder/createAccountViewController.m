//
//  createAccountViewController.m
//  Event-Finder
//
//  Created by David Mattia on 1/18/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

#import "createAccountViewController.h"
#import <Parse/Parse.h>

@interface createAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *password1TextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;

@end

@implementation createAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Create User Account";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEventButtonPressed:(id)sender {
    // Create user with given information
    // then return to login view
    PFUser *newUser = [PFUser user];
    newUser[@"firstName"] = self.firstNameTextField.text;
    newUser[@"lastName"] = self.lastNameTextField.text;
    newUser.email = self.emailTextField.text;
    newUser[@"age"] = [NSNumber numberWithInt:[self.ageTextField.text intValue]];
    newUser.username = self.usernameTextField.text;
    if([self.password1TextField.text isEqualToString:self.password2TextField.text]) {
        newUser.password = self.password1TextField.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Could not save user. Check internet connection"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Account Created Successfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [self performSegueWithIdentifier:@"goToLogInSegue" sender:self];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Passwords must match"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

@end
