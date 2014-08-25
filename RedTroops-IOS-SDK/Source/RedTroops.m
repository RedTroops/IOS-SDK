//
//  RedTroops.m
//  RedTroopsDemo
//
//  Created by Omar on 9/26/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "RedTroops.h"
#import "RTCommonInfo.h"
#import "RTPushNotificationManager.h"
#import "RTRequestManager.h"
#import "BannersViewController.h"
#import "RTNagView.h"

@implementation RedTroops
id<RedTroopsDataProtocol> delegate;

+ (void)startSessionWithAppKey:(NSString *)apiKey AppId:(NSString*)appId andDeviceType:(NSString*)deviceType
{
    // 2.2
    [RTCommonInfo setRedTroopsAppKey:apiKey];
    [RTCommonInfo setRedTroopsAppID:appId];
    [RTCommonInfo setDeviceType:deviceType];
    [RTCommonInfo setCurrentTime:[NSDate date]];
}

+ (void)endSession
{
    // 2.3
    @autoreleasepool
    {
		NSMutableDictionary *params =
        [NSMutableDictionary
         dictionaryWithObjectsAndKeys:
         @"regSession", @"fcn",
         @"Push", @"appLaunch",
         nil];
        
        [RTCommonInfo fillCustomInfo:params];
        
		NSError *error = nil;
		[[RTRequestManager sharedManager] sendRequest:params
                                             response:NULL
                                                error:&error
                                       andRequestType:kRequestForEndSession];
	}
}


+ (void)handlePushRegistration:(NSData *)devToken
{
    
    // 1.2
    NSMutableString *deviceID = [NSMutableString stringWithString:[devToken description]];
    
    
	//Remove <, >, and spaces
	[deviceID replaceOccurrencesOfString:@"<" withString:@"" options:1 range:NSMakeRange(0, [deviceID length])];
	[deviceID replaceOccurrencesOfString:@">" withString:@"" options:1 range:NSMakeRange(0, [deviceID length])];
	[deviceID replaceOccurrencesOfString:@" " withString:@"" options:1 range:NSMakeRange(0, [deviceID length])];
	
	[[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:DEVICE_USERDEFAULTS];
    [RTCommonInfo setDeviceToken:deviceID];
    
    [RTPushNotificationManager handlePushRegistration:deviceID];
}

+ (void)processRemoteNotification:(NSDictionary *)infoDict
{
    [RTPushNotificationManager processRemoteNotification:infoDict];
}


+ (void)listBannerHTML5WithDelegate:(id<RedTroopsDataProtocol>)del
                            failure:(void (^)(NSError *error))failureBlock
{
    //4.3
    @autoreleasepool
    {
        delegate = del;
		NSMutableDictionary *params =
        [NSMutableDictionary
         dictionaryWithObjectsAndKeys:
         @"Push", @"appLaunch",
         [RTCommonInfo currentTime], @"actioneTime",
         nil];
        
        
        [RTCommonInfo fillCustomInfo:params];
        
        dispatch_async
        (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
         ^{
             __block NSError *error = nil;
             NSString *response = nil;
             [[RTRequestManager sharedManager] sendRequest:params
                                                  response:&response
                                                     error:&error
                                            andRequestType:kRequestForBannerLsit];

             
             dispatch_async
             (dispatch_get_main_queue(), ^{
                 if (error)
                 {
                     failureBlock(error);
                 }
                 else
                 {
                     
                     NSData *postData = [response dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                     if (postData == nil) {
                         NSLog(@"Response of Push Notification: Response is nil");
                         return;
                     }
                     NSDictionary* json = [NSJSONSerialization
                                           JSONObjectWithData:postData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
                     
                     if ((int)[[json valueForKey:@"success"] integerValue] == 1) {
                         
                         if ([json objectForKey:@"data"] && [[json objectForKey:@"data"] objectForKey:@"banners"]) {
                             NSLog(@"Banners:\n%@",[[json objectForKey:@"data"] objectForKey:@"banners"]);
                             NSArray *jsonResult = [[json objectForKey:@"data"] objectForKey:@"banners"];
                             // successBlock([self parseBanners:jsonResult]);
                             [self parseBanners:jsonResult];
                         }
                     } else {
                         NSLog(@"No Banners");
                         // there are no banners
                     }
                     
                 }
             });
         });
	}
}

+(void)showBannerListWithView:(UIViewController*)view
{
    // 4.1
    BannersViewController *controller = [[BannersViewController alloc] init];
    [controller showBannerList];
    [view.navigationController pushViewController:controller animated:YES];

}
+ (void)downloadImageInApp:(NSArray*)bannerList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *finalPath;
    __block NSInteger listSize = [bannerList count];
    __block int noOfDownloadFiles = 0;
    for (int i = 0; i < bannerList.count; i++) {
        
        finalPath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"bannerImage%i.png",i]];
        
        dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        
        dispatch_async(imageQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[bannerList objectAtIndex:i] imageURL]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([data writeToFile:finalPath atomically:YES])
                {
                    NSLog(@"-----Image saved");
                } else{
                    NSLog(@"----Image not saved");
                }
                noOfDownloadFiles++;
                if ((noOfDownloadFiles == listSize) && [delegate respondsToSelector:@selector(getBannerListRequestCompleted:)]) {
                    [delegate getBannerListRequestCompleted:bannerList];
                }
            });
            
        });
        
        
    }
    
}
+ (NSArray*)parseBanners:(NSArray*)dicBanners
{
    // 4.4
    @try {
        NSMutableArray *retBanners = [NSMutableArray new];
        // NSMutableArray *retBannersUrl = [NSMutableArray new];
        for (NSDictionary *dic in dicBanners) {
            RedTroopsBanner *banner = [RedTroopsBanner new];
            
            banner.bannerType = [dic objectForKey:@"type"];
            banner.URL = [NSURL URLWithString:[dic objectForKey:@"url"]];
            banner.imageURL = [dic objectForKey:@"image_url"];
            banner.bannerID = [dic objectForKey:@"id"];
            
            [retBanners addObject:banner];
        }
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"RedTroopsImagesDownloaded"]) {
            [self downloadImageInApp:retBanners];
            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:@"RedTroopsImagesDownloaded"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ( [delegate respondsToSelector:@selector(getBannerListRequestCompleted:)]) {
            [delegate getBannerListRequestCompleted:retBanners];
        }
        return retBanners;
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    return nil;
}

+(void)showHTML5ImagePopup:(UIViewController*)viewController
{
    // 3.2
    @autoreleasepool
    {
        //fill input with default params
		NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [RTCommonInfo fillCustomInfo:params];
        
        //remove ad id to make a call with empty ad
        [params removeObjectForKey:@"ad_id"];
        
        // 3.3
        RTNagView *nagView = [[RTNagView alloc] init];
        nagView.popUpParam = params;
        [nagView showInView:viewController.view];
       // nagView.center = CGPointMake(viewController.view.frame.size.width/2, viewController.view.frame.size.height / 2);
        [viewController.view bringSubviewToFront:nagView];
	}
}

+(void)showHTML5ImagePopup:(UIViewController*)viewController withId:(NSString*)adId
{
    // 3.2
    @autoreleasepool
    {
        //fill input with default params
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [RTCommonInfo fillCustomInfo:params];
        
        //NSLog(@"showHTML5ImagePopup WITH ID:: %@", [params valueForKey:@"ad_id"]);

        //replace ad id
        //[params setValue:adId forKey:@"ad_id"];
        [params setObject:adId forKey:@"ad_id"];
        
        // 3.3
        RTNagView *nagView = [[RTNagView alloc] init];
        nagView.popUpParam = params;
        [nagView showInView:viewController.view];
        // nagView.center = CGPointMake(viewController.view.frame.size.width/2, viewController.view.frame.size.height / 2);
        [viewController.view bringSubviewToFront:nagView];
	}
}

@end
