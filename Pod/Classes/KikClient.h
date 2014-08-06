//
//  KikClient.h
//  Pods
//
//  Created by Anthony Wong on 2014-08-06.
//  Copyright (c) 2014 Kik Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "KikMessage.h"

@interface KikClient : NSObject

+ (KikClient *)sharedInstance;

- (void)backToKik;

- (void)openProfileForKikUsername:(NSString *)username;

- (void)sendKikMessage:(KikMessage *)message;

- (void)setRootController:(UIViewController *)viewController;

@property (nonatomic, strong) UIViewController *rootController;

@end
