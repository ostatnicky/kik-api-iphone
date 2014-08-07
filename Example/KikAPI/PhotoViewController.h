//
//  PhotoViewController.h
//  KikAPI
//
//  Created by Anthony Wong on 2014-08-06.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *imageURLField;
@property (weak, nonatomic) IBOutlet UITextField *previewURLField;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

- (IBAction)pictureButtonTouched:(id)sender;
- (IBAction)sendButtonTouched:(id)sender;

@end
