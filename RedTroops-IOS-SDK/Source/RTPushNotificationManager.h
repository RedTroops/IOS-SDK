//
//  RTPushManager.h
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEVICE_USERDEFAULTS @"RTPushDeviceId"

@interface RTPushNotificationManager : NSObject

+ (void)handlePushRegistration:(NSString *)devToken;
+ (void)processRemoteNotification:(NSDictionary *)infoDict;

@end