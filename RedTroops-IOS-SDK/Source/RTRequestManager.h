//
//  RTRequestManager.h
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kRequestForSendingDeviceToken,
    kRequestForEndSession,
    kRequestForBannerLsit
}RequestSendType;
@interface RTRequestManager : NSObject

+ (RTRequestManager *) sharedManager;

- (BOOL) sendRequest:(NSDictionary *)params
            response:(NSString**)retResponse
               error:(NSError **)retError
      andRequestType:(RequestSendType)rType;



@end
