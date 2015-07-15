//
//  RTVideo.h
//  iOSSDK
//
//  Created by RedTroops.
//  Copyright (c) 2015 RedTroops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTAdSize.h"
#import <MediaPlayer/MediaPlayer.h>

@class MPMoviePlayerController;


@interface RTVideo : UIView
{
}

-(id)initWithSize:(RTAdType)adType;
@property (nonatomic, assign) RTAdType ADType;
@property (nonatomic, strong) NSNumber *adId;

-(void)prepareAd;
-(void)playAd;


- (void)addObserveForKeyPath:(NSString *)keyPath withBlock:(void (^)())block;
- (void)unobserveKeyPath:(NSString *)keyPath;

@end

