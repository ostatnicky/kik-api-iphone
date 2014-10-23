//
//  ArticleViewController.m
//  KikAPI
//
//  Created by Anthony Wong on 2014-08-06.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import "ArticleViewController.h"
#import <KikAPI/KikAPI.h>

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Article";
    
    self.sendButton.layer.borderWidth = 0.5f;
    self.sendButton.layer.borderColor = [self.sendButton.tintColor CGColor];
    self.sendButton.layer.cornerRadius = 6.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}

- (IBAction)sendTouched:(id)sender
{
    NSString *title = self.articleTitleField.text;
    NSString *text = self.articleTextField.text;
    NSString *contentURL = self.urlField.text;
    NSString *previewURL = self.previewField.text;
    
    KikMessage *message = [KikMessage articleMessageWithTitle:title
                                                         text:text
                                                   contentURL:contentURL
                                                   previewURL:previewURL];
    
    if (message) {
        [[KikClient sharedInstance] sendKikMessage:message];
    }
}
@end
