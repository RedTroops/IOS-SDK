//
//  RTNotificationManager.h
//  iOSSDK
//
//  Created by RedTroops
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTNotificationManager : NSObject

+(RTNotificationManager *)defaultManager;
-(void)startProcessingNotificationPayload:(NSDictionary *)payload;

@end
