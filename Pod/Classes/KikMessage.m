//
//  KikMessage.m
//  Pods
//
//  Created by Anthony Wong on 2014-08-05.
//  Copyright (c) 2014 Kik Interactive. All rights reserved.
//

#define KIK_MESSENGER_API_SEND_URL      @"kik-share://kik.com/send/"
#import <UIKit/UIKit.h>
#import "KikMessage.h"
#import "NSString+URLEncoding.h"

@interface KikMessage ()

- (id)initWithTitle:(NSString *)title
               text:(NSString *)text
         contentURL:(NSString *)contentURL;

- (id)initWithImageURL:(NSString *)imageURL
            previewURL:(NSString *)previewURL;

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appPackage;
@property (nonatomic, strong) NSString *iconURL;
@end

@implementation KikMessage

#pragma mark - Public Methods

+ (KikMessage *)articleMessageWithTitle:(NSString *)title
                                   text:(NSString *)text
                             contentURL:(NSString *)contentURL
{
    return [[KikMessage alloc] initWithTitle:title
                                        text:text
                                  contentURL:contentURL];
}

+ (KikMessage *)photoMessageWithImageURL:(NSString *)imageURL
                              previewURL:(NSString *)previewURL
{
    return [[KikMessage alloc] initWithImageURL:imageURL
                                     previewURL:previewURL];
}

- (void)addFallbackURL:(NSString *)fallbackURL
           forPlatform:(KikMessagePlatform)platform
{
    if (![NSURL URLWithString:fallbackURL]) {
        return;
    }
    
    NSUInteger currentPriority = _URLs.count;
    
    NSString *stringPlatform;
    
    switch (platform) {
        case KikMessagePlatformAndroid:
            stringPlatform = @"android";
            break;
        case KikMessagePlatformiPhone:
            stringPlatform = @"iphone";
            break;
        case KikMessagePlatformCards:
            stringPlatform = @"cards";
            break;
        default:
            stringPlatform = @"";
            break;
    }
    
    NSDictionary *uri;
    
    uri = @{@"priority": @(currentPriority),
            @"value": fallbackURL};
    
    if (stringPlatform.length) {
        uri = @{@"priority": @(currentPriority),
                @"value": fallbackURL,
                @"platform": stringPlatform};
    } else {
        uri = @{@"priority": @(currentPriority),
                @"value": fallbackURL};
    }
    
    [_URLs addObject:uri];
}

- (void)send
{
    NSString *link = [self linkRepresentation];
    NSURL *url = [NSURL URLWithString:link];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
    } else {
        
    }
}

#pragma mark - Private Methods

- (id)initWithTitle:(NSString *)title
               text:(NSString *)text
         contentURL:(NSString *)contentURL
{
    if (![NSURL URLWithString:contentURL]) {
        return nil;
    }
    
    if (!title && !text) {
        return nil;
    }
    
    if (self = [super init]) {
        _type = KikMessageTypeArticle;
        _title = title;
        _text = text;
        _URLs = [NSMutableArray arrayWithObject:@{@"value": contentURL}];
    }
    
    return self;
}

- (id)initWithImageURL:(NSString *)imageURL
            previewURL:(NSString *)previewURL
{
    if (![NSURL URLWithString:imageURL] || ![NSURL URLWithString:previewURL]) {
        return nil;
    }
    
    if (self = [super init]) {
        _type = KikMessageTypePhoto;
        _imageURL = imageURL;
        _previewURL = previewURL;
        _URLs = [NSMutableArray array];
        
    }
    
    return self;
}

- (NSString *)linkRepresentation
{
    NSString *link = KIK_MESSENGER_API_SEND_URL;
    
    if (_type == KikMessageTypeArticle) {
        link = [link stringByAppendingString:@"article?"];
    } else {
        link = [link stringByAppendingString:@"photo?"];
    }
    
    link = [link stringByAppendingString:[NSString stringWithFormat:@"app_name=%@",_appName]];
    link = [link stringByAppendingString:[NSString stringWithFormat:@"&app_pkg=%@",_appPackage]];
    
    if (_title.length) {
        link = [link stringByAppendingString:[NSString stringWithFormat:@"&title=%@",_title]];
    }
    
    if (_text.length) {
        link = [link stringByAppendingString:[NSString stringWithFormat:@"&text=%@",_text]];
    }
    
    if (_forwardable) {
        link = [link stringByAppendingString:@"&forwardable=1"];
    } else {
        link = [link stringByAppendingString:@"&forwardable=0"];
    }
    
    for (NSDictionary *uri in _URLs) {
        NSString *platform = uri[@"platform"];
        NSString *value = [uri[@"value"] urlEncodeUsingEncoding:NSUTF8StringEncoding];
        
        if (platform.length) {
            link = [link stringByAppendingString:[NSString stringWithFormat:@"&url=%@,%@", platform, value]];
        } else {
            link = [link stringByAppendingString:[NSString stringWithFormat:@"&url=%@", value]];
        }
    }
    
    if (_imageURL.length) {
        if ([_imageURL hasPrefix:@"data:"]) {
            link = [link stringByAppendingString:[NSString stringWithFormat:@"&image_url=%@", _imageURL]];
        } else {
            link = [link stringByAppendingString:[NSString stringWithFormat:@"&image_url=%@",
                                                  [_imageURL urlEncodeUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    
    if (_previewURL.length) {
        if ([_previewURL hasPrefix:@"data:"]) {
            link = [link stringByAppendingString:[NSString stringWithFormat:@"&preview_url=%@", _previewURL]];
        } else {
            link = [link stringByAppendingString:[NSString stringWithFormat:@"&preview_url=%@",
                                                  [_previewURL urlEncodeUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    
    link = [link stringByAppendingString:[NSString stringWithFormat:@"&icon_url=%@", self.iconURL]];
    
    link = [link stringByAppendingString:@"&native=1"];
    
    link = [link stringByAppendingString:[NSString stringWithFormat:@"&referer=%@", _appPackage]];
    
    return link;
}

- (NSString *)appName
{
    if (!_appName) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *appName = [[NSFileManager defaultManager] displayNameAtPath:bundlePath];
        _appName = appName;
    }
    
    return _appName;
}

- (NSString *)appPackage
{
    if (!_appPackage) {
        _appPackage = [[NSBundle mainBundle] bundleIdentifier];
    }

    return _appPackage;
}

- (NSString *)iconURL
{
    if (!_iconURL) {
        // Try to find the icon from the bundles
        UIImage *appIcon = [UIImage imageNamed:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFiles"] objectAtIndex:0]];
        
        // Maybe stored in .xcasset style?
        if (!appIcon) {
            appIcon = [UIImage imageNamed: [[[[[[NSBundle mainBundle] infoDictionary]
                                               objectForKey:@"CFBundleIcons"]
                                              objectForKey:@"CFBundlePrimaryIcon"]
                                             objectForKey:@"CFBundleIconFiles"]
                                            objectAtIndex:0]];
        }
        
        // Fall back if we can't find any icon at all
        if (!appIcon) {
            appIcon = [UIImage imageNamed:@"app_store_icon"];
        }
        
        // Convert to base64
        NSData *iconData = UIImagePNGRepresentation(appIcon);
        
        if (!iconData) {
            return nil;
        }
        
        NSData *encodedIconData = [iconData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *base64 = [NSString stringWithUTF8String:[encodedIconData bytes]];
        
        _iconURL = [NSString stringWithFormat:@"data:image/png;base64,%@", base64];
    }
    
    return _iconURL;
}
@end
