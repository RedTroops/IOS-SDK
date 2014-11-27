//
//  SessionManager.h
//  iOSSDK
//
//  Created by RedTroops
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTSessionManager : NSObject

+(RTSessionManager *)defaultManager;

@property (nonatomic, strong) NSString *sessionId;

-(void)startSessionWithAPIKey:(NSString *)APIKey;
-(void)endSession;
-(void)registerDeviceToken:(NSData *)deviceToken;

@end
