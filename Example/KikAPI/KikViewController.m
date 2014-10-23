//
//  KikViewController.m
//  KikAPI
//
//  Created by Anthony Wong on 08/05/2014.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import "KikViewController.h"
#import <KikAPI/KikAPI.h>
#import <QuartzCore/QuartzCore.h>

@interface KikViewController () <UIAlertViewDelegate>

@end

@implementation KikViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"API Demo";
    
    self.profileButton.layer.borderWidth = 0.5f;
    self.profileButton.layer.borderColor = [self.profileButton.tintColor CGColor];
    self.profileButton.layer.cornerRadius = 6.0f;
    
    self.articleMessageButton.layer.borderWidth = 0.5f;
    self.articleMessageButton.layer.borderColor = [self.articleMessageButton.tintColor CGColor];
    self.articleMessageButton.layer.cornerRadius = 6.0f;
    
    self.photoMessageButton.layer.borderWidth = 0.5f;
    self.photoMessageButton.layer.borderColor = [self.photoMessageButton.tintColor CGColor];
    self.photoMessageButton.layer.cornerRadius = 6.0f;
    
    self.backButton.layer.borderWidth = 0.5f;
    self.backButton.layer.borderColor = [self.backButton.tintColor CGColor];
    self.backButton.layer.cornerRadius = 6.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profileButtonTouched:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Open Profile"
                                                        message:@"Enter a Kik Username"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Open", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

- (IBAction)backButtonTouched:(id)sender
{
    [[KikClient sharedInstance] backToKik];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        
        if (username.length) {
            [[KikClient sharedInstance] openProfileForKikUsername:username];
        }
    }
}
@end
