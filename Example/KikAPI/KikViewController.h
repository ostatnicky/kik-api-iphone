//
//  KikViewController.h
//  KikAPI
//
//  Created by Anthony Wong on 08/05/2014.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KikViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *articleMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *photoMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)profileButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end
