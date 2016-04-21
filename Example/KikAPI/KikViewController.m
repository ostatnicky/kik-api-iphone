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

#import "ContentViewController.h"

static NSString * const ContentCaptureSegueIdentifier = @"ContentCaptureSegueIdentifier";

@interface KikViewController () <UIAlertViewDelegate>

@end

@implementation KikViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
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
    
    self.videoMessageButton.layer.borderWidth = 0.5f;
    self.videoMessageButton.layer.borderColor = [self.videoMessageButton.tintColor CGColor];
    self.videoMessageButton.layer.cornerRadius = 6.0f;
    
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

#pragma mark - Action Responders

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

- (IBAction)imageButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:ContentCaptureSegueIdentifier sender:@"Image"];
}

- (IBAction)videoButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:ContentCaptureSegueIdentifier sender:@"Video"];
}

- (IBAction)backButtonTouched:(id)sender
{
    [[KikClient sharedInstance] backToKik];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        
        if (username.length) {
            [[KikClient sharedInstance] openProfileForKikUsername:username];
        }
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ContentCaptureSegueIdentifier]) {
        ContentViewController *contentVC = (ContentViewController *)segue.destinationViewController;
        contentVC.isPhoto = [sender isEqualToString:@"Image"];
    }
}

@end
