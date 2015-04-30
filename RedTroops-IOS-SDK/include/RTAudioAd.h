//
//  RTAudioAd.h
//  iOSSDK
//
//  Created by RedTroops on 4/30/15.
//  Copyright (c) 2015 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTAdSize.h"


@interface RTAudioAd : NSObject

-(id)initWithSize:(RTAdType)adType;

@property (nonatomic, assign) RTAdType ADType;
@property (nonatomic, strong) NSNumber *adId;

-(void)playAudioAd;

@end
