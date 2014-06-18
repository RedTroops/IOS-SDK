//
//  RedTroops.h
//  RedTroopsDemo
//
//  Created by Omar on 9/26/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedTroopsBanner.h"

@protocol RedTroopsDataProtocol <NSObject>

-(void)getBannerListRequestCompleted:(NSArray*)bannerList;

@end

@interface RedTroops : NSObject
{
   
}
//Session management
+ (void)startSessionWithAppKey:(NSString *)apiKey
               AppId:(NSString*)appId
       andDeviceType:(NSString*)deviceType;

//Push notification
+ (void)handlePushRegistration:(NSData *)devToken ;

// Process remote notification
+ (void)processRemoteNotification:(NSDictionary *)infoDict;


// User end session
+ (void)endSession;


// HTML5/Image popup add
+(void)showHTML5ImagePopup:(UIViewController*)view;
+(void)showHTML5ImagePopup:(UIViewController*)viewController withId:(NSString*)adId;

// HTML5 list banner
+(void)showBannerListWithView:(UIViewController*)view;

// HTML5 list banner
+ (void)listBannerHTML5WithDelegate:(id<RedTroopsDataProtocol>)del
                failure:(void (^)(NSError *error))failureBlock;

@end
