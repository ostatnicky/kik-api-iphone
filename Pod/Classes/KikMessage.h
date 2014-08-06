//
//  KikMessage.h
//  Pods
//
//  Created by Anthony Wong on 2014-08-05.
//  Copyright (c) 2014 Kik Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KikMessageTypeArticle = 0,
    KikMessageTypePhoto
} KikMessageType;

typedef enum {
    KikMessagePlatformGeneric = 0,
    KikMessagePlatformiPhone,
    KikMessagePlatformAndroid,
    KikMessagePlatformCards
} KikMessagePlatform;

@interface KikMessage : NSObject

@property (nonatomic, assign, readonly) KikMessageType type;
@property (nonatomic, strong, readonly) NSString *appName;
@property (nonatomic, strong, readonly) NSString *appPackage;
@property (nonatomic, strong, readonly) NSString *iconURL;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSString *previewURL;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, assign) BOOL forwardable;

@property (nonatomic, strong, readonly) NSMutableArray *URLs;

+ (KikMessage *)articleMessageWithTitle:(NSString *)title
                                   text:(NSString *)text
                             contentURL:(NSString *)contentURL;

+ (KikMessage *)photoMessageWithImageURL:(NSString *)imageURL
                              previewURL:(NSString *)previewURL;

- (void)addFallbackURL:(NSString *)fallbackURL
           forPlatform:(KikMessagePlatform)platform;

- (NSString *)linkRepresentation;

@end
