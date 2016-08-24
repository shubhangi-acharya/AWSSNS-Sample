//
//  ViewController.m
//  AWSSNS-Sample
//
//  Created by Shubhangi Pandya on 24/08/16.
//  Copyright © 2016 Shubhangi Pandya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ViewController enableRemoteNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)enableRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [application registerForRemoteNotifications];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    
    [ViewController setUpNotifcation];
}

+ (void)setUpNotifcation {
    // Sets up Mobile Push Notification
    UIMutableUserNotificationAction *readAction = [UIMutableUserNotificationAction new];
    readAction.identifier = @"READ_IDENTIFIER";
    readAction.title = @"Read";
    readAction.activationMode = UIUserNotificationActivationModeForeground;
    readAction.destructive = NO;
    readAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *deleteAction = [UIMutableUserNotificationAction new];
    deleteAction.identifier = @"DELETE_IDENTIFIER";
    deleteAction.title = @"Delete";
    deleteAction.activationMode = UIUserNotificationActivationModeForeground;
    deleteAction.destructive = YES;
    deleteAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *ignoreAction = [UIMutableUserNotificationAction new];
    ignoreAction.identifier = @"IGNORE_IDENTIFIER";
    ignoreAction.title = @"Ignore";
    ignoreAction.activationMode = UIUserNotificationActivationModeForeground;
    ignoreAction.destructive = NO;
    ignoreAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *messageCategory = [UIMutableUserNotificationCategory new];
    messageCategory.identifier = @"MESSAGE_CATEGORY";
    [messageCategory setActions:@[readAction, deleteAction] forContext:UIUserNotificationActionContextMinimal];
    [messageCategory setActions:@[readAction, deleteAction, ignoreAction] forContext:UIUserNotificationActionContextDefault];
}


@end
