//
//  RTCommonInfo.h
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RTCommonInfo : NSObject

+ (NSString *) uniqueGlobalDeviceIdentifier;

+ (NSString*) appBundleId;
+ (NSString*) appVersion;
+ (NSString*) appDisplayName;

+ (NSString*) currentLocale;

+ (void)setRedTroopsAppKey:(NSString*)appKey;
+ (NSString*)redTroopsAppKey;

+ (void)setUserID:(NSString*)userId;
+ (NSString*)userID;

+ (void) setRedTroopsAppID:(NSString*)appID;
+ (NSString*) redTroopsAppID;

+ (void) setDeviceType:(NSString*)devType;
+ (NSString*) deviceType;

+ (void) setCurrentTime:(NSDate*)curTime;
+ (NSDate*) currentTime;

+ (NSString*) iOSVersion;

+ (NSString*) deviceToken;
+ (void) setDeviceToken:(NSString*)deviceToken;

+ (void)fillCustomInfo:(NSDictionary*)dictionary;

@end
