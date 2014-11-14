//
//  RTNotificationManager.h
//  iOSSDK
//
//  Created by Rami Arafat on 10/2/14.
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTNotificationManager : NSObject

+(RTNotificationManager *)defaultManager;
-(void)startProcessingNotificationPayload:(NSDictionary *)payload;

@end
