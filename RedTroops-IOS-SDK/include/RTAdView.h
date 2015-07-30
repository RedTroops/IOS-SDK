//
//  RTAdView.h
//  iOSSDK
//
//  Created by RedTroops
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTAdSize.h"
#import "RTAdRequest.h"

@interface RTAdView : UIView

-(id)initWithSize:(RTAdType)adType;

@property (nonatomic, assign) RTAdType ADType;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, assign) BOOL hasAd;
@property (nonatomic, strong) NSNumber *adId;

-(void)loadRequest:(RTAdRequest *)request;
-(void)loadRequest;
-(void)prepareAd;
-(void)removeTheAd;
-(void)showAd;

-(int)checkAdAvailability;

@end
