//
//  ContentViewController.m
//  KikAPI
//
//  Created by Anthony Wong on 2014-08-06.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import "ContentViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <KikAPI/KikAPI.h>

@interface ContentViewController () < UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    UITextFieldDelegate,
                                    UIActionSheetDelegate>

@property (strong, nonatomic) UIImage *imageToSend;
@property (strong, nonatomic) NSData *videoDataToSend;

@end

@implementation ContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isPhoto) {
        self.title = @"Photo";
        self.contentURLField.placeholder = @"Fullsize Image URL (Required)";
        [self.pictureButton setTitle:@"Take or Choose a Picture" forState:UIControlStateNormal];
        self.videoToggleView.hidden = YES;
    } else {
        self.title = @"Video";
        self.contentURLField.placeholder = @"Fullsize Video URL (Required)";
        [self.pictureButton setTitle:@"Take or Choose a Video" forState:UIControlStateNormal];
    }
    
    self.sendButton.layer.borderWidth = 0.5f;
    self.sendButton.layer.borderColor = [self.sendButton.tintColor CGColor];
    self.sendButton.layer.cornerRadius = 6.0f;
    
    self.pictureButton.layer.borderWidth = 0.5f;
    self.pictureButton.layer.borderColor = [self.pictureButton.tintColor CGColor];
    self.pictureButton.layer.cornerRadius = 6.0f;
    
}

- (void)disableURLFields
{
    self.contentURLField.text = @"Content has been provided";
    self.contentURLField.textColor = [UIColor redColor];
    self.contentURLField.enabled = NO;
    
    self.previewURLField.text = self.contentURLField.text;
    self.previewURLField.textColor = self.contentURLField.textColor;
    self.previewURLField.enabled = self.contentURLField.enabled;
}

#pragma mark - Action Responders

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
    KikMessage *messageToSend;
    
    if (self.isPhoto) {
        messageToSend = [self constructPhotoKikMessage];
    } else {
        messageToSend = [self constructVideoKikMessage];
        messageToSend.videoShouldAutoplay = self.autoplayToggle.on;
        messageToSend.videoShouldBeMuted = self.mutedToggle.on;
        messageToSend.videoShouldLoop = self.loopsToggle.on;
    }
    
    if (messageToSend) {
        [[KikClient sharedInstance] sendKikMessage:messageToSend];
    }
}

#pragma mark - KikMessage Construction

- (KikMessage *)constructPhotoKikMessage
{
    if (self.imageToSend) {
        return [KikMessage photoMessageWithImage:self.imageToSend];
    }
    
    if (self.contentURLField.text.length && self.previewURLField.text.length) {
        return [KikMessage photoMessageWithImageURL:self.contentURLField.text
                                         previewURL:self.previewURLField.text];
        
    }
    
    return nil;
}

- (KikMessage *)constructVideoKikMessage
{
    if (self.videoDataToSend) {
        return [KikMessage videoMessageWithData:self.videoDataToSend];
    }
    
    if (self.contentURLField.text.length && self.previewURLField.text.length) {
        return [KikMessage videoMessageWithVideoURL:self.contentURLField.text
                                         previewURL:self.previewURLField.text];
        
    }
    
    return nil;
}

#pragma mark - Actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (buttonIndex == 0) {
            [self startMediaBrowserFromViewController:self];
            return;
        }
        if (buttonIndex == 1) {
            [self startCameraControllerFromViewController:self];
            return;
        }
    } else {
        self.imageToSend = nil;
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
{
    
    if ((![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        || (controller == nil))
        return NO;
    
    [self launchImageControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    
    return YES;
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController*) controller
{
    
    if ((![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        || (controller == nil))
        return NO;
    
    [self launchImageControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    return YES;
}

- (void)launchImageControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = sourceType;
    mediaUI.delegate = self;
    
    if (self.isPhoto) {
        mediaUI.mediaTypes = @[
                               (__bridge NSString *)kUTTypeImage
                               ];
    } else {
        mediaUI.mediaTypes = @[
                               (__bridge NSString *)kUTTypeMovie
                               ];
    }
    
    
    [self presentViewController:mediaUI
                             animated:YES
                           completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    // Handle a still image capture
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage, *editedImage, *imageToSave;
        
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        self.imageToSend = imageToSave;
        
        [self.pictureImageView setImage:self.imageToSend];
    }
    
    // Handle a video 
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
        if (!mediaURL) {
            mediaURL = info[UIImagePickerControllerReferenceURL];
        }
        
        // Video Data passed into the KikMessage initializer
        _videoDataToSend = [NSData dataWithContentsOfURL:mediaURL];
        
        // Get the thumbnail to show which video we are using.
        AVAsset *asset1 = [AVAsset assetWithURL:mediaURL];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
        
        [self.pictureImageView setImage:one];
    }
    
    [self disableURLFields];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
