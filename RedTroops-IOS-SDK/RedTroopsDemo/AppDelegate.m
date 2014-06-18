//
//  AppDelegate.m
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "RedTroops.h"

@interface AppDelegate() {
    
    int badge_value;
}

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    application.applicationIconBadgeNumber = 0;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    // change here, just add Api_Key and Id here
    [RedTroops startSessionWithAppKey:@"0d124d6d803d3c52c23557ecac595074" AppId:@"2" andDeviceType:@"ios"];

    //notification
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ( userInfo != nil )
    {
        [RedTroops processRemoteNotification:userInfo];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [RedTroops handlePushRegistration:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIRemoteNotificationType status = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (status == UIRemoteNotificationTypeNone)
    {
        NSLog(@"didReceiveRemoteNotification:User doesn't want to receive push-notifications");
    }
    [RedTroops processRemoteNotification:userInfo];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [RedTroops endSession];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

@end
