//
//  RTPushManager.m
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "RTPushNotificationManager.h"
#import "RTCommonInfo.h"
#import "RTRequestManager.h"
#import "AppDelegate.h"
#import "RedTroops.h"
#import "AppDelegate.h"

NSString *RED_TROOPS_BASE_URL = @"http://developer.redtroops.com/api/";
NSString *RED_TROOPS_START_UP = @"startup";
NSString *RED_TROOPS_END_SESSION = @"session";
NSString *RED_TROOPS_GET_ADS = @"getAd";
NSString *RED_TROOPS_GET_ADS_LIST = @"getList";
NSString *RED_TROOPS_SHOW_ADS = @"showAd";


@implementation RTPushNotificationManager

+ (void)handlePushRegistration:(NSString *)devToken
{
    NSLog(@"Device Token: %@", [RTCommonInfo deviceToken]);

    // 1.3
	[self performSelectorInBackground:@selector(sendDevTokenToServer:) withObject:devToken];
}

+ (void)sendDevTokenToServer:(NSString *)deviceID
{
    // 1.4
	@autoreleasepool
    {
		NSMutableDictionary *params =
        [NSMutableDictionary
         dictionaryWithObjectsAndKeys:
         @"registerApp", @"fcn",
         deviceID, @"token",
         @"Push", @"appLaunch",
         [RTCommonInfo currentTime], @"registrationTime",
         nil];
        
        [RTCommonInfo fillCustomInfo:params];
        
		NSError *error = nil;
		[[RTRequestManager sharedManager] sendRequest:params
                                             response:NULL
                                                error:&error
                                       andRequestType:kRequestForSendingDeviceToken];
	}
}

+ (void)resetBadge
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
}



+ (void)processRemoteNotification:(NSDictionary *)infoDict
{
        //redTroopsAdID
    if ([infoDict objectForKey:@"aps"] != NULL )
    {
        //get ad id
        NSString *adID = [[infoDict objectForKey:@"aps"] objectForKey:@"ad_id"];
        
        //show the popup
        AppDelegate *appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
        [RedTroops showHTML5ImagePopup:appDelegate.window.rootViewController withId:adID];
    }
    //reset badge
    [RTPushNotificationManager resetBadge];
}




@end
