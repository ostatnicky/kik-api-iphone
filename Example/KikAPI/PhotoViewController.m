//
//  PhotoViewController.m
//  KikAPI
//
//  Created by Anthony Wong on 2014-08-06.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import "PhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface PhotoViewController () < UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    UITextFieldDelegate,
                                    UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *imageToSend;

@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Photo";
    
    self.sendButton.layer.borderWidth = 0.5f;
    self.sendButton.layer.borderColor = [[UIColor greenColor] CGColor];
    self.sendButton.layer.cornerRadius = 6.0f;
    
    self.pictureButton.layer.borderWidth = 0.5f;
    self.pictureButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.pictureButton.layer.cornerRadius = 6.0f;
    
}

- (IBAction)pictureButtonTouched:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Gallery", @"Camera", nil];
    
    [sheet showInView:self.view];
}

- (IBAction)sendButtonTouched:(id)sender
{
    
}

#pragma mark - Actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (buttonIndex == 0) {
            [self startMediaBrowserFromViewController:self
                                        usingDelegate:self];
            return;
        }
        if (buttonIndex == 1) {
            [self startCameraControllerFromViewController:self
                                            usingDelegate:self];
            return;
        }
    }
}

#pragma mark - Textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - Camera Stuff

- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                   usingDelegate:(id<UIImagePickerControllerDelegate,
                                                  UINavigationControllerDelegate>)delegate
{
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI
                             animated:YES
                           completion:nil];
    return YES;
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController*) controller
                               usingDelegate:(id<UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>)delegate
{
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI
                             animated:YES
                           completion:nil];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        self.imageToSend = imageToSave;
        
        self.imageURLField.enabled = NO;
        self.previewURLField.enabled = NO;
        
        [self.pictureImageView setImage:self.imageToSend];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
