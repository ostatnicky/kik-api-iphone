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
	// Do any additional setup after loading the view, typically from a nib.

    
    self.profileButton.layer.borderWidth = 0.5f;
    self.profileButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileButton.layer.cornerRadius = 6.0f;
    
    self.articleMessageButton.layer.borderWidth = 0.5f;
    self.articleMessageButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.articleMessageButton.layer.cornerRadius = 6.0f;
    
    self.photoMessageButton.layer.borderWidth = 0.5f;
    self.photoMessageButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.photoMessageButton.layer.cornerRadius = 6.0f;
    
    self.backButton.layer.borderWidth = 0.5f;
    self.backButton.layer.borderColor = [[UIColor greenColor] CGColor];
    self.backButton.layer.cornerRadius = 6.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.alpha = 1.0f;
    [super viewWillAppear:animated];

    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = 0.0f;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.alpha = 0.0f;

    [super viewWillDisappear:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = 1.0f;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profileButtonTouched:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Kik Profile"
                                                        message:@"Enter a username"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Open", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
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
