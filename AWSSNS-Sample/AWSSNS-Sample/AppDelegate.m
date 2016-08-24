//
//  AppDelegate.m
//  AWSSNS-Sample
//
//  Created by Shubhangi Pandya on 24/08/16.
//  Copyright © 2016 Shubhangi Pandya. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSCore/AWSCore.h>
#import <AWSSNS/AWSSNS.h>

static NSString *const SNSPlatformApplicationArn = @"YOUR-ENDPOINT-ARN";
static NSString *const CognitoPoolid = @"YOUR-POOL_ID";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"iOSDeviceToken"];
    // Login To Cognito
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:CognitoPoolid];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    AWSSNSCreatePlatformEndpointInput *endPointInput = [[AWSSNSCreatePlatformEndpointInput alloc] init];
    endPointInput.platformApplicationArn = SNSPlatformApplicationArn;
    endPointInput.token = token;
    AWSSNS *sns = [AWSSNS defaultSNS];
    [[sns createPlatformEndpoint:endPointInput] continueWithBlock:^id(AWSTask *task) {
        if(task.error != nil)
        {
            NSLog(@"%@", task.error);
        } else {
            AWSSNSCreateEndpointResponse *createEndPointResponse = task.result;
            [[NSUserDefaults standardUserDefaults] setObject:createEndPointResponse.endpointArn forKey:@"endpointArn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSelectorOnMainThread:@selector(saveSNSTokenToServer) withObject:nil waitUntilDone:NO];
        }
        return nil;
    }];
}

- (void)saveSNSTokenToServer {
    NSString *endPointARN = [[NSUserDefaults standardUserDefaults] objectForKey:@"endpointArn"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"iOSDeviceToken"];
    
    NSLog(@"%@, %@", endPointARN, deviceToken);
    
    // Write code to call API where u can send EndpointARN and device token to server, so that server can communicate the with device with this details.
}

@end
