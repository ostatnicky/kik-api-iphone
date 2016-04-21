//
//  ContentViewController.h
//  KikAPI
//
//  Created by Anthony Wong on 2014-08-06.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *contentURLField;
@property (weak, nonatomic) IBOutlet UITextField *previewURLField;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UIView *videoToggleView;
@property (weak, nonatomic) IBOutlet UISwitch *loopsToggle;
@property (weak, nonatomic) IBOutlet UISwitch *autoplayToggle;
@property (weak, nonatomic) IBOutlet UISwitch *mutedToggle;

@property (assign, nonatomic) BOOL isPhoto;

- (IBAction)pictureButtonTouched:(id)sender;
- (IBAction)sendButtonTouched:(id)sender;

@end
