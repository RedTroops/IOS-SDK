//
//  RTAdRequest.h
//  iOSSDK
//
//  Created by Rami Arafat
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTAdSize.h"
#import "RTAdvertisement.h"


@interface RTAdRequest : NSObject

+(RTAdRequest *)request;



-(void)retrieveAdWithType:(RTAdType)adType adId:(NSNumber *)adId aspectRatio:(NSString *)aspect_ratio success:(void (^)(RTAdvertisement *ad))success failure:(void (^)(NSError *error))failure;




@end
